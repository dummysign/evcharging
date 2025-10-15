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

  // Get global stock list
  static Future<List<Map<String, dynamic>>> getStockList() async {
    final db = await database;
    return await db.query('stock_list');
  }

  // Fetch all products with batches
  Future<List<Product>> getAllProducts() async {
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
            pricePerUnit: b['pricePerUnit'] as double,
            purchaseDate: DateTime.parse(b['purchaseDate'] as String),
          );
        }).toList(),
      ));
    }
    return products;
  }

  Future<void> updateBatchStock(int productId, DateTime date, double stock) async {
    final db = await database;
    await db.update(
      'batches',
      {'stock': stock},
      where: 'productId = ? AND purchaseDate = ?',
      whereArgs: [productId, date.toIso8601String()],
    );
  }
}
