import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../app/data/Product.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create table for monthly product batches
        await db.execute('''
          CREATE TABLE IF NOT EXISTS product_batches (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            batchId TEXT,
            englishName TEXT,
            hindiName TEXT,
            brandName TEXT,
            unitType TEXT,
            quantityBought REAL,
            quantityRemaining REAL,
            totalPaid REAL,
            perUnitCost REAL,
            profitType TEXT,
            profitValue REAL,
            gstPercent REAL,
            suggestedPrice REAL,
            isLoose INTEGER,
            date TEXT,
            monthKey TEXT
          )
        ''');

        // Create global stock list table
        await db.execute('''
    CREATE TABLE IF NOT EXISTS stock_list (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    batchId TEXT,
    englishName TEXT,
    hindiName TEXT,
    brandName TEXT,
    unitType TEXT,
    quantityBought REAL,
    quantityRemaining REAL,
    totalPaid REAL,
    perUnitCost REAL,
    profitType TEXT,
    profitValue REAL,
    gstPercent REAL,
    suggestedPrice REAL,
    isLoose INTEGER,
    date TEXT,
    monthKey TEXT   -- ✅ Added this line
  )
''');

        // Create sales table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS sales (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productName TEXT,
            hindiName TEXT,
            batchId TEXT,
            qty REAL,
            unit TEXT,
            price REAL,
            pricePerUnit REAL,
            saleDate TEXT,
            monthKey TEXT,
            yearKey TEXT
          )
        ''');

        await db.execute('''
  CREATE TABLE IF NOT EXISTS grouped_sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    customerName TEXT,
    paymentMode TEXT,
    totalAmount REAL,
    date TEXT,
    monthKey TEXT,
    yearKey TEXT,
    items TEXT   -- JSON string of all sold items
  )
''');

      },
    );
  }

  // Insert into a specific table
  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data);
  }

  // Read by monthKey
  static Future<List<Map<String, dynamic>>> getByMonth(String monthKey) async {
    final db = await database;
    return await db.query(
      'product_batches',
      where: 'monthKey = ?',
      whereArgs: [monthKey],
    );
  }

  // Insert a sale
  static Future<void> insertSale({
    required String productName,
    required String hindiName,
    required String batchId,
    required double qty,
    required String unit,
    required double price,
    required double pricePerUnit,
  }) async {
    final db = await database;
    final now = DateTime.now();
    final monthKey = "${now.year}_${now.month.toString().padLeft(2, '0')}";
    final yearKey = "${now.year}";

    final sale = {
      'productName': productName,
      'hindiName': hindiName,
      'batchId': batchId,
      'qty': qty,
      'unit': unit,
      'price': price,
      'pricePerUnit': pricePerUnit,
      'saleDate': now.toIso8601String(),
      'monthKey': monthKey,
      'yearKey': yearKey,
    };

    await db.insert('sales', {
      'productName': productName,
      'hindiName': hindiName,
      'batchId': batchId,
      'qty': qty,
      'unit': unit,
      'price': price,
      'pricePerUnit': pricePerUnit,
      'saleDate': now.toIso8601String(),
      'monthKey': monthKey,
      'yearKey': yearKey,
    });

    // Cloud Firestore
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc("123");

    // ✅ Step 1: Add the sale
    await userRef.collection('sales').add(sale);

    // ✅ Step 2: Ensure the stock document exists before updating
    final stockDoc = userRef.collection('stock_list').doc(batchId);
    final stockSnapshot = await stockDoc.get();

    if (stockSnapshot.exists) {
      // Update quantity safely
      await stockDoc.update({
        'quantityRemaining': FieldValue.increment(-qty),
      });
    } else {
      // If not found, recreate stock entry with reduced qty
      await stockDoc.set({
        'batchId': batchId,
        'quantityRemaining': -qty, // or handle gracefully
      }, SetOptions(merge: true));
    }

  /*  await stockDoc.update({
      'quantityRemaining': FieldValue.increment(-qty),
    });*/
  }



  // Get global stock list
  static Future<List<Map<String, dynamic>>> getStockList() async {
    final db = await database;
    return await db.query('stock_list');
  }

  // Fetch all products with batches
 /* Future<List<Product>> getAllProducts() async {
    final db = await database;
    final productList = await db.query('products');

    List<Product> products = [];
    for (var prod in productList) {
      final batches = await db.query('batches',
          where: 'productId = ?', whereArgs: [prod['id']]);
      products.add(Product(
        name: prod['name'] as String,
        hindiName: prod['hindiName'] as String,
        brandName: prod['brandName'] as String,
        unit: prod['unit'] as String,
        batches: batches.map((b) {
          return ProductBatch(
            stock: b['stock'] as double,
            stock: b['stock'] as double,
            pricePerUnit: b['pricePerUnit'] as double,
            purchaseDate: DateTime.parse(b['purchaseDate'] as String),
          );
        }).toList(),
      ));
    }
    return products;
  }*/

  Future<void> updateBatchStock(int productId, DateTime date, double stock) async {
    final db = await database;
    await db.update(
      'batches',
      {'stock': stock},
      where: 'productId = ? AND purchaseDate = ?',
      whereArgs: [productId, date.toIso8601String()],
    );
  }

  // Total stock count (sum of quantityRemaining)
  static Future<double> getTotalStock() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM(quantityRemaining) as totalStock FROM stock_list');
    return result.first['totalStock'] != null
        ? (result.first['totalStock'] as num).toDouble()
        : 0.0;
  }

  // Total inventory value (sum of quantityRemaining * perUnitCost)
  static Future<double> getTotalValue() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT SUM(quantityRemaining * perUnitCost) as totalValue FROM stock_list');
    return result.first['totalValue'] != null
        ? (result.first['totalValue'] as num).toDouble()
        : 0.0;
  }

  // Low stock items count
  static Future<int> getLowStockCount(int threshold) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as lowStockCount FROM stock_list WHERE quantityRemaining <= ?',
        [threshold]);
    return result.first['lowStockCount'] != null
        ? (result.first['lowStockCount'] as int)
        : 0;
  }

  // Fast movers (most sold items)
  static Future<List<String>> getFastMovers(int limit) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT productName, SUM(qty) as totalSold
      FROM sales
      GROUP BY productName
      ORDER BY totalSold DESC
      LIMIT ?
    ''', [limit]);

    return result.map((e) => e['productName'] as String).toList();
  }

  // Stock by category
  static Future<Map<String, double>> getStockByCategory() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT unitType, SUM(quantityRemaining) as total
      FROM stock_list
      GROUP BY unitType
    ''');

    Map<String, double> data = {};
    for (var row in result) {
      data[row['unitType'] as String] =
          (row['total'] as num?)?.toDouble() ?? 0;
    }
    return data;
  }

  // Recent sales
  // Recent sales
  static Future<List<Map<String, dynamic>>> getRecentSales(int limit) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT productName, qty, price, saleDate
      FROM sales
      ORDER BY saleDate DESC
      LIMIT ?
    ''', [limit]);
    return result;
  }

  /// Optionally, get stock by batchId
  static Future<double> getStockByBatch(String batchId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT quantityRemaining 
      FROM stock_list 
      WHERE batchId = ?
      ''',
      [batchId],
    );

    return result.isNotEmpty
        ? (result.first['quantityRemaining'] as num).toDouble()
        : 0.0;
  }

  // Daily sales report
  static Future<List<Map<String, dynamic>>> getSalesByDate(DateTime date) async {
    final db = await database;
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(Duration(days: 1));

    return await db.query(
      'sales',
      where: 'saleDate >= ? AND saleDate < ?',
      whereArgs: [dayStart.toIso8601String(), dayEnd.toIso8601String()],
    );
  }

  // Monthly sales report
  static Future<List<Map<String, dynamic>>> getSalesByMonth(String monthKey) async {
    final db = await database;
    return await db.query(
      'sales',
      where: 'monthKey = ?',
      whereArgs: [monthKey],
    );
  }

  // Yearly sales report
  static Future<List<Map<String, dynamic>>> getSalesByYear(String yearKey) async {
    final db = await database;
    return await db.query(
      'sales',
      where: 'yearKey = ?',
      whereArgs: [yearKey],
    );
  }

  // Get top 3 low stock items
  static Future<List<Map<String, dynamic>>> getTopLowStockItems() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT englishName, quantityRemaining, date
    FROM stock_list
    ORDER BY quantityRemaining ASC
    LIMIT 3
  ''');

    return result;


  }

  static Future<List<Map<String, dynamic>>> getSalesByDateRange(DateTime start, DateTime end) async {
    final db = await database;

    final result = await db.query(
      'grouped_sales',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [DateFormat('yyyy-MM-dd').format(start),  DateFormat('yyyy-MM-dd').format(end)],
      orderBy: 'date DESC',
    );

    return result.map((e) {
      final customerName = e["customerName"]?.toString() ?? "";
      final paymentMode = e["paymentMode"]?.toString() ?? "";
      final totalAmountValue = e["totalAmount"];
      final totalAmount = (totalAmountValue is num)
          ? totalAmountValue.toStringAsFixed(2)
          : double.tryParse(totalAmountValue?.toString() ?? "0")?.toStringAsFixed(2) ?? "0.00";
      final dateValue = e["date"]?.toString() ?? "";

      String formattedDate;
      try {
        formattedDate = DateTime.parse(dateValue).toString().split(" ")[0];
      } catch (_) {
        formattedDate = dateValue;
      }

      return {
        "customerName": customerName,
        "paymentMode": paymentMode,
        "totalAmount": totalAmount,
        "date": formattedDate,
        "items": e["items"], // store for detail view
      };
    }).toList();
  }
 /* static Future<List<Map<String, dynamic>>> getSalesByDateRange(DateTime start, DateTime end) async {
    final db = await database;

    final result = await db.query(
      'grouped_sales',
      orderBy: 'date DESC',
    );

    return result.map((e) {
      final productName = e["customerName"]?.toString() ?? "";
      final qty = e["paymentMode"]?.toString() ?? "0";
      final priceValue = e["totalAmount"];
      final price = (priceValue is num)
          ? priceValue.toStringAsFixed(2)
          : double.tryParse(priceValue?.toString() ?? "0")?.toStringAsFixed(2) ?? "0.00";
      final dateValue = e["date"]?.toString() ?? "";

      // Safely parse date
      String formattedDate;
      try {
        formattedDate = DateTime.parse(dateValue).toString().split(" ")[0];
      } catch (_) {
        formattedDate = dateValue; // fallback if parsing fails
      }

      return {
        "product": productName,
        "qty": qty,
        "price": price,
        "date": formattedDate,
      };
    }).toList();
  }*/

  static Future<void> insertGroupedSale({
    required String customerName,
    required String paymentMode,
    required List<Map<String, dynamic>> items, // all sold products
  }) async {
    final db = await database;
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc("123");

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final monthKey = "${now.year}_${now.month.toString().padLeft(2, '0')}";
    final yearKey = "${now.year}";

    // ✅ Calculate total amount
    final totalAmount = items.fold<double>(
      0,
          (sum, item) => sum + (item["price"] as double),
    );

    // ✅ Prepare grouped sale data
    final saleData = {
      "customerName": customerName,
      "paymentMode": paymentMode,
      "totalAmount": totalAmount,
      "date": formattedDate,
      "monthKey": monthKey,
      "yearKey": yearKey,
      "items": items,
    };

    // ✅ Save to Firestore
    await userRef.collection("sales").add(saleData);

    // ✅ Save locally (store items as JSON)
    await db.insert('grouped_sales', {
      "customerName": customerName,
      "paymentMode": paymentMode,
      "totalAmount": totalAmount,
      "date": formattedDate,
      "monthKey": monthKey,
      "yearKey": yearKey,
      "items": jsonEncode(items),
    });

    // ✅ Update stock for each sold product
    for (var item in items) {
      final stockDoc = userRef.collection('stock_list').doc(item["batchId"]);
      final stockSnapshot = await stockDoc.get();

      if (stockSnapshot.exists) {
        await stockDoc.update({
          "quantityRemaining": FieldValue.increment(-item["qty"]),
        });
      } else {
        await stockDoc.set({
          "batchId": item["batchId"],
          "quantityRemaining": -item["qty"],
        }, SetOptions(merge: true));
      }
    }
  }

}
