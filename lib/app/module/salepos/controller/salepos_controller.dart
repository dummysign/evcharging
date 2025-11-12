import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/api/data/db_helper.dart';
import '../../../data/Customer.dart';
import '../../../data/Product.dart';

class ShopController extends GetxController {

  final dbHelper = DBHelper();

  var products = <Product>[].obs;
  var cart = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadCustomers();
  }

  Future<void> loadProducts() async {
    try {
      final stockRows = await DBHelper.getStockList();

      if (stockRows.isEmpty) {
        // no data in DB → empty list (or optionally insert defaults)
        products.value = [];
        return;
      }

      // Group stock rows by englishName
      final grouped = <String, List<Map<String, dynamic>>>{};
      for (var row in stockRows) {
        final name = row['englishName'] ?? '';
        grouped.putIfAbsent(name, () => []).add(row);
      }

      // Convert to Product objects
      products.value = grouped.entries.map((entry) {
        final first = entry.value.first;
        final batches = entry.value.map((b) {
          return ProductBatch(
            batchid: (b['batchId'] ?? ""),
            stock: (b['quantityRemaining'] ?? 0).toDouble(),
            pricePerUnit: (b['suggestedPrice'] ?? 0).toDouble(),
            purchaseDate: DateTime.tryParse(b['date'] ?? '') ?? DateTime.now(),
          );
        }).toList();

        return Product(
          name: first['englishName'] ?? '',
          hindiName: first['hindiName'] ?? '',
          brandName: first['brandName'] ?? '',
          unit: first['unitType'] ?? '',
          batches: batches,
        );
      }).toList();
    } catch (e) {
      print("❌ Error loading products: $e");
      products.value = [];
    }
  }


 /* void sellProduct(Product product, double qty, double price, ProductBatch batch) async {
    if (qty <= batch.stock) {
      batch.stock -= qty;

      cart.add({
        "product": product,
        "name": product.name,
        "batch": batch,
        "hindiName": product.hindiName,
        "qty": qty,
        "unit": product.unit,
        "price": price,
        "pricePerUnit": batch.pricePerUnit,
        "batchDate": batch.purchaseDate,
      });

     *//* await dbHelper.updateBatchStock(
        product.. ?? 0,
        batch.purchaseDate,
        batch.stock,
      );*//*

      products.refresh();
      cart.refresh();
    } else {
      Get.snackbar("Stock Error", "Not enough stock available!");
    }
  }*/


  void sellProduct(
      Product product,
      double qty,
      double price,
      ProductBatch batch,
      String unit,
      ) async {
    // ✅ Always convert everything to base unit (kg/ltr)
    final saleInBaseUnit = qty * _getUnitFactor(unit); // use sale unit
    final stockInBaseUnit = batch.stock * _getUnitFactor(product.unit); // use product unit

    print("Sale in base unit: $saleInBaseUnit");
    print("Stock in base unit: $stockInBaseUnit");

    if (saleInBaseUnit <= stockInBaseUnit) {
      // Subtract in base unit
      final newStockBase = stockInBaseUnit - saleInBaseUnit;

      // Convert back to product’s unit
      batch.stock = newStockBase / _getUnitFactor(product.unit);

      cart.add({
        "product": product,
        "name": product.name,
        "batch": batch,
        "hindiName": product.hindiName,
        "qty": qty,
        "unit": unit, // ✅ Use the sale unit, not product.unit
        "price": price,
        "pricePerUnit": batch.pricePerUnit,
        "batchDate": batch.purchaseDate,
      });

      /*// ✅ Update in DB
      final db = await DBHelper.database;
      await db.update(
        'stock_list',
        {'quantityRemaining': batch.stock},
        where: 'englishName = ? AND date = ?',
        whereArgs: [product.name, batch.purchaseDate.toIso8601String()],
      );*/

      products.refresh();
      cart.refresh();
    } else {
      Get.snackbar("Stock Error", "Not enough stock available!");
    }
  }


 /* void completeSale() async {
    final db = await DBHelper.database;

    for (var item in cart) {
      Product product = item["product"];
      ProductBatch batch = item["batch"];
      double qty = item["qty"];
      String unit = item["unit"];

      // Convert both to base units (so kg/gm, etc. align)
      final saleInBase = qty * _getUnitFactor(unit);
      final stockInBase = batch.stock * _getUnitFactor(product.unit);

      print("Sale in base unitqq: $saleInBase");
      print("Stock in base unitqq: $stockInBase");

      if (saleInBase <= stockInBase) {
        final newStockBase = stockInBase - saleInBase;
        batch.stock = newStockBase / _getUnitFactor(product.unit);

        // ✅ Update in local DB
        await db.update(
          'stock_list',
          {'quantityRemaining': batch.stock},
          where: 'englishName = ? AND date = ?',
          whereArgs: [product.name, batch.purchaseDate.toIso8601String()],
        );
      } else {
        Get.snackbar("Stock Error", "Not enough stock available for ${product.name}");
      }
    }

    // Clear cart and refresh UI
    cart.clear();
    products.refresh();
  }*/


 /* void completeSale() async {
    final db = await DBHelper.database;

    for (var item in cart) {
      Product product = item["product"];
      ProductBatch batch = item["batch"];
      double qty = item["qty"];
      String unit = item["unit"];
      double price =  item["price"];

      // Convert to base units
      final saleInBase = qty * _getUnitFactor(unit);

      // ✅ Get the current stock from DB for this batch
      final currentStock = await DBHelper.getStockByBatch(batch.batchid as String);
      final stockInBase = currentStock * _getUnitFactor(product.unit);

      print("Sale in base unit: $saleInBase");
      print("Stock in base unit: $stockInBase");

      if (saleInBase <= stockInBase) {
        final newStockBase = stockInBase - saleInBase;
        final newStock = newStockBase / _getUnitFactor(product.unit);

        // Update batch object locally
        batch.stock = newStock;

        await DBHelper.insertSale(
          productName: product.name,
          hindiName: product.hindiName,
          batchId: batch.batchid,
          qty: qty,
          unit: unit,
          price: price,
          pricePerUnit: batch.pricePerUnit,
        );

        // Update in DB
        await db.update(
          'stock_list',
          {'quantityRemaining': newStock},
          where: 'batchId = ?',
          whereArgs: [batch.batchid],
        );
      } else {
        Get.snackbar("Stock Error", "Not enough stock available for ${product.name}");
      }
    }

    // Clear cart and refresh UI
    cart.clear();
    products.refresh();
  }*/


  void completeSale({
    required String customerName,
    required String paymentMode,
  }) async {
    final db = await DBHelper.database;

    // 1️⃣ Collect all items in the sale
    List<Map<String, dynamic>> saleItems = [];
    double totalAmount = 0;

    for (var item in cart) {
      Product product = item["product"];
      ProductBatch batch = item["batch"];
      double qty = item["qty"];
      String unit = item["unit"];
      double price = item["price"];

      final saleInBase = qty * _getUnitFactor(unit);
      final currentStock = await DBHelper.getStockByBatch(batch.batchid as String);
      final stockInBase = currentStock * _getUnitFactor(product.unit);

      if (saleInBase > stockInBase) {
        Get.snackbar("Stock Error", "Not enough stock for ${product.name}");
        return; // Stop the whole sale if any item fails
      }

      saleItems.add({
        "productName": product.name,
        "hindiName": product.hindiName,
        "batchId": batch.batchid,
        "qty": saleInBase,
        "unit": unit,
        "price": price,
        "pricePerUnit": batch.pricePerUnit,
      });

      totalAmount += price;
    }

    // 2️⃣ Save the grouped sale (in Firestore + SQLite)
    await DBHelper.insertGroupedSale(
      customerName: customerName,
      paymentMode: paymentMode,
      items: saleItems,
    );

    // 3️⃣ Update stock locally for each sold batch
    for (var item in saleItems) {
      final batchId = item["batchId"];
      final qty = item["qty"] as double;

      final currentStock = await DBHelper.getStockByBatch(batchId);
      final newStock = currentStock - qty;

      await db.update(
        'stock_list',
        {'quantityRemaining': newStock},
        where: 'batchId = ?',
        whereArgs: [batchId],
      );
    }


    // 4️⃣ Clear cart and refresh UI
    cart.clear();
    products.refresh();

    // 5️⃣ Optionally show confirmation
    Get.snackbar("Sale Complete", "₹${totalAmount.toStringAsFixed(2)} sale saved successfully!");
  }



  double get total => cart.fold(
      0, (sum, item) => sum + ((item['price'] ?? 0) /** (item['qty'] ?? 0)*/));

  void clearCart() => cart.clear();

  var customers = <Customer>[].obs;

  Future<void> loadCustomers() async {
    try {
      final dbCustomers = await DBHelper.getAllKhatas();
      final localCustomers = dbCustomers.map((row) {
        return Customer(
          name: (row['customerName'] ?? '').toString(),
          hindiName: (row['customerName'] ?? '').toString(),
          phone: row['phone']?.toString() ?? '',
          totalDue: (row['totalDue'] is num)
              ? (row['totalDue'] as num).toDouble()
              : double.tryParse(row['totalDue']?.toString() ?? '0') ?? 0.0,
        );
      }).toList();

      // 🟢 Try Firebase too (if internet available)
      List<Customer> firebaseCustomers = [];
      try {
        final firestore = FirebaseFirestore.instance;
        final snapshot = await firestore
            .collection('users')
            .doc('123')
            .collection('khata')
            .get();

        firebaseCustomers = snapshot.docs.map((doc) {
          final data = doc.data();
          return Customer(
            name: (data['customerName'] ?? '').toString(),
            hindiName: (data['customerName'] ?? '').toString(),
            phone: (data['phone'] ?? '').toString(),
            totalDue: (data['totalDue'] is num)
                ? (data['totalDue'] as num).toDouble()
                : double.tryParse(data['totalDue']?.toString() ?? '0') ?? 0.0,
          );
        }).toList();
      } catch (e) {
        print("⚠️ Firebase fetch failed, using local only: $e");
      }

      // 🟢 Merge both lists — remove duplicates (by phone or name)
      final merged = <Customer>[];

      for (var c in [...localCustomers, ...firebaseCustomers]) {
        final exists = merged.any((x) =>
        ((x.phone ?? '').isNotEmpty && x.phone == c.phone) ||
            (x.name.trim().toLowerCase() == c.name.trim().toLowerCase()));

        if (!exists) merged.add(c);
      }

      customers.assignAll(merged);

      print("✅ Loaded ${customers.length} customers with khata");
    } catch (e) {
      print("❌ Error loading khata customers: $e");
    }
  }

  void addToKhata(Customer customer) async {
    final db = await DBHelper.database;
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('users').doc('123');

    double totalAmount = 0;
    List<Map<String, dynamic>> items = [];

    for (var item in cart) {
      Product product = item["product"];
      ProductBatch batch = item["batch"];
      double qty = item["qty"];
      String unit = item["unit"];
      double price = item["price"];

      // 🧾 Add to local khata transaction list
      items.add({
        "productName": product.name,
        "hindiName": product.hindiName,
        "qty": qty,
        "unit": unit,
        "price": price,
        "date": DateTime.now().toIso8601String(),
      });

      totalAmount += price;

      // ✅ Update stock
      final saleInBase = qty * _getUnitFactor(unit);
      final stockInBase = batch.stock * _getUnitFactor(product.unit);

      if (saleInBase <= stockInBase) {
        final newStockBase = stockInBase - saleInBase;
        batch.stock = newStockBase / _getUnitFactor(product.unit);

        await db.update(
          'stock_list',
          {'quantityRemaining': batch.stock},
          where: 'englishName = ? AND date = ?',
          whereArgs: [product.name, batch.purchaseDate.toIso8601String()],
        );
      } else {
        Get.snackbar("Stock Error", "Not enough stock for ${product.name}");
      }
    }

    // 🟢 Check if khata exists locally
    final existing = await db.query(
      'khata_records',
      where: 'phone = ?',
      whereArgs: [customer.phone ?? ''],
    );

    if (existing.isNotEmpty) {
      // ✅ Add to existing khata
      final record = existing.first;
      final transactions = jsonDecode((record['transactions'] ?? '[]').toString()) as List;

      transactions.add({
        "date": DateTime.now().toIso8601String(),
        "amount": totalAmount,
        "note": "Items purchased",
        "items": items,
        "paid": false,
      });

      final newTotal = ((record['totalDue'] ?? 0) as num) + totalAmount;

      await db.update(
        'khata_records',
        {
          "transactions": jsonEncode(transactions),
          "totalDue": newTotal,
          "lastUpdated": DateTime.now().toIso8601String(),
        },
        where: 'phone = ?',
        whereArgs: [customer.phone ?? ''],
      );
    } else {
      // ✅ Create new khata record
      final newRecord = {
        "customerName": customer.name,
        "phone": customer.phone ?? '',
        "totalDue": totalAmount,
        "transactions": jsonEncode([
          {
            "date": DateTime.now().toIso8601String(),
            "amount": totalAmount,
            "note": "Items purchased",
            "items": items,
            "paid": false,
          }
        ]),
        "lastUpdated": DateTime.now().toIso8601String(),
      };

      await db.insert('khata_records', newRecord);
    }

    // ✅ Now update Firebase without overwriting
    final docRef = userRef.collection('khata').doc(customer.phone ?? customer.name);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      // 🟢 Append to existing transactions
      final data = docSnap.data()!;
      final rawTransactions = data['transactions'];
      final existingTransactions = (rawTransactions is String)
          ? jsonDecode(rawTransactions)
          : (rawTransactions is List ? rawTransactions : []);

      existingTransactions.add({
        "date": DateTime.now().toIso8601String(),
        "amount": totalAmount,
        "note": "Items purchased",
        "items": items,
        "paid": false,
      });

      final newTotal = (data['totalDue'] ?? 0) + totalAmount;

      await docRef.update({
        "transactions": existingTransactions,
        "totalDue": newTotal,
        "lastUpdated": DateTime.now().toIso8601String(),
      });
    } else {
      // 🟠 First time — create new document
      await docRef.set({
        "customerName": customer.name,
        "phone": customer.phone ?? '',
        "totalDue": totalAmount,
        "transactions": [
          {
            "date": DateTime.now().toIso8601String(),
            "amount": totalAmount,
            "note": "Items purchased",
            "items": items,
            "paid": false,
          }
        ],
        "lastUpdated": DateTime.now().toIso8601String(),
      });
    }

    cart.clear();
    products.refresh();
    completeSale(customerName : customer.name,paymentMode :"Khata");
    updateCustomerTotals(phone :customer.phone!,purchaseAmount :totalAmount, dueAmount : totalAmount);

    Get.snackbar(
      "खाता अपडेट हुआ",
      "${customer.name} के खाते में ₹${totalAmount.toStringAsFixed(2)} जोड़ा गया",
      backgroundColor: Colors.green.shade100,
    );
  }


  static Future<void> updateCustomerTotals({
    required String phone,
    double? purchaseAmount,
    double? dueAmount,
  }) async {
    final db = await DBHelper.database;
    final existing = await db.query('customers', where: 'phone = ?', whereArgs: [phone]);
    if (existing.isEmpty) return;

    final row = existing.first;
    final newTotalPurchases =
        ((row['totalPurchases'] as num?)?.toDouble() ?? 0) + (purchaseAmount ?? 0);
    final newTotalDue =
        ((row['totalDue'] as num?)?.toDouble() ?? 0 )+ (dueAmount ?? 0);

    await db.update(
      'customers',
      {
        'totalPurchases': newTotalPurchases,
        'totalDue': newTotalDue,
        'lastPurchaseDate': DateTime.now().toIso8601String(),
      },
      where: 'phone = ?',
      whereArgs: [phone],
    );
  }


/*  void addToKhata(Customer customer) async {
    final db = await DBHelper.database;

    for (var item in cart) {
      Product product = item["product"];
      ProductBatch batch = item["batch"];
      double qty = item["qty"];
      String unit = item["unit"];

      // 1️⃣ Record the transaction in customer ledger
    *//*  customer.ledger.add({
        "productName": item['name'],
        "productHindiName": item['hindiName'],
        "qty": qty,
        "unit": unit,
        "price": item['price'],
        "date": DateTime.now(),
      });*//*

      // 2️⃣ Update stock in base units
      final saleInBase = qty * _getUnitFactor(unit);
      final stockInBase = batch.stock * _getUnitFactor(product.unit);

      if (saleInBase <= stockInBase) {
        final newStockBase = stockInBase - saleInBase;
        batch.stock = newStockBase / _getUnitFactor(product.unit);

        await db.update(
          'stock_list',
          {'quantityRemaining': batch.stock},
          where: 'englishName = ? AND date = ?',
          whereArgs: [product.name, batch.purchaseDate.toIso8601String()],
        );
      } else {
        Get.snackbar("Stock Error", "Not enough stock available for ${product.name}");
      }
    }

    // 3️⃣ Clear cart
    cart.clear();
    products.refresh();
  }*/


  double _getUnitFactor(String? unit) {
    switch (unit?.toLowerCase()) {
      case 'kg':
      case 'ltr':
        return 1.0; // base
      case 'g':
      case 'gm':
      case 'ml':
        return 0.001; // 1 gm/ml = 0.001 kg/ltr
      case 'pcs':
      case 'piece':
        return 1.0;
      default:
        return 1.0;
    }
  }


  /*final box = GetStorage();

  // Reactive product list
  var products = <Product>[].obs;

  // Cart
  var cart = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    final saved = box.read('products');
    if (saved != null) {
      products.value = (saved as List)
          .map((p) => Product.fromJson(Map<String, dynamic>.from(p)))
          .toList();
    } else {
      // If no data, initialize default products
      products.value = [
        Product(
          name: "rice",
          hindiName: "चावल",
          brandName: "baba",
          unit: "kg",
          batches: [
            ProductBatch(
                stock: 24,
                pricePerUnit: 75.83,
                purchaseDate: DateTime(2025, 10, 1)),
            ProductBatch(
                stock: 24,
                pricePerUnit: 67.50,
                purchaseDate: DateTime(2025, 11, 1)),
          ],
        ),
        Product(
          name: "Sugar",
          hindiName: "चीनी",
          brandName: "baba",
          unit: "gm",
          batches: [
            ProductBatch(stock: 5000, pricePerUnit: 40, purchaseDate: DateTime.now())
          ],
        ),
        // Add more products here...
      ];
      saveProducts();
    }
  }

  void saveProducts() {
    box.write('products', products.map((p) => p.toJson()).toList());
  }


  void sellProduct(Product product, double qty, double price, ProductBatch batch) {
    if (qty <= batch.stock) {
      batch.stock -= qty;
      cart.add({
        "product": product,
        "name": product.name,
        "batch": batch,
        "hindiName": product.hindiName,
        "qty": qty,
        "unit": product.selectedUnit,
        "price": price,
        "pricePerUnit": batch.pricePerUnit,
        "batchDate": batch.purchaseDate,
      });
      products.refresh();
      cart.refresh();
      // --- Update storage ---
      final box = GetStorage();
      List<dynamic> storedList = box.read("stockList") ?? [];

      // Find the product in storage
      final index = storedList.indexWhere((p) => p["name"] == product.name);
      if (index != -1) {
        final storedProduct = storedList[index];

        // Find the batch in storage by purchase date
        final batchIndex = (storedProduct["batches"] as List)
            .indexWhere((b) => b["purchaseDate"] == batch.purchaseDate.toIso8601String());

        if (batchIndex != -1) {
          storedProduct["batches"][batchIndex]["stock"] = batch.stock;
        }

        storedList[index] = storedProduct;
        box.write("stockList", storedList); // persist updated stock
      }
    } else {
      Get.snackbar("Stock Error", "Not enough stock available!");
    }
  }

  double getUnitFactor(String unit) {
    switch (unit) {
      case 'kg':
      case 'ltr':
        return 1.0; // base unit
      case 'gm':
      case 'ml':
        return 0.001; // 1 gm = 0.001 kg, 1 ml = 0.001 l
      case 'piece':
        return 1.0; // pieces don't need conversion
      default:
        return 1.0;
    }
  }


  // Sell product: supports multiple batches (FIFO)
 *//* void sellProduct(String productName, double qty, double sellingPrice) {
    final product =
    products.firstWhereOrNull((p) => p.name == productName);

    if (product == null) {
      Get.snackbar("Error", "Product not found");
      return;
    }

    double remainingQty = qty;

    // Sort batches oldest first
    product.batches.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));

    for (var batch in product.batches) {
      if (remainingQty <= 0) break;

      double sellQty = remainingQty > batch.stock ? batch.stock : remainingQty;
      if (sellQty <= 0) continue;

      batch.stock -= sellQty;
      remainingQty -= sellQty;

      cart.add({
        "name": product.name,
        "hindiName": product.hindiName,
        "qty": sellQty,
        "unit": product.unit,
        "sellingPrice": sellingPrice,
        "purchasePrice": batch.pricePerUnit,
        "purchaseDate": batch.purchaseDate.toIso8601String(),
      });
    }

    if (remainingQty > 0) {
      Get.snackbar(
        "Stock Warning",
        "Only ${qty - remainingQty} ${product.unit} sold. Not enough stock!",
      );
    }

    products.refresh();
    cart.refresh();
    saveProducts(); // persist stock
  }*//*

  void completeSale() {
    final box = GetStorage();
    List<dynamic> storedList = box.read("stockList") ?? [];

    for (var item in cart) {
      Product product = item["product"];
      ProductBatch batch = item["batch"];
      double qty = item["qty"];

      // Subtract from batch stock
      batch.stock -= qty;

      // Update storage
      final index = storedList.indexWhere((p) =>
      p["englishName"] == product.name &&
          p["brandName"] == product.brandName
      );
     // final index = storedList.indexWhere((p) => p["name"] == product.name);
      if (index != -1) {
        final storedProduct = storedList[index];
        final batchIndex = (storedProduct["batches"] as List)
            .indexWhere((b) => b["purchaseDate"] == batch.purchaseDate.toIso8601String());
        if (batchIndex != -1) {
          storedProduct["batches"][batchIndex]["stock"] = batch.stock;
        }
        storedList[index] = storedProduct;
      }
    }

    box.write("stockList", storedList);

    // Clear cart
    cart.clear();

    // Refresh product list in UI
    products.refresh();
  }


  // Cart total
  double get total =>
      cart.fold(0, (sum, item) => sum + ((item['sellingPrice'] ?? 0) * (item['qty'] ?? 0)));

  void clearCart() => cart.clear();

  var customers = <Customer>[
    Customer(name: "Ramesh Kumar", hindiName: "रामेश कुमार"), Customer(name: "Sita Devi", hindiName: "सीता देवी"), ].obs; void addToKhata(Customer customer) { for (var item in cart)
    { customer.ledger.add({ "productName": item['name'], "productHindiName": item['hindiName'], "qty": item['qty'], "unit": item['unit'], "price": item['price'], "date": DateTime.now(), }); }
  cart.clear(); }*/
}
