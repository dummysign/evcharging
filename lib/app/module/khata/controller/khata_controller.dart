import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../../common/api/data/db_helper.dart';
import '../../../data/Customer.dart';
import '../../../data/Product.dart';

class KhataController extends GetxController {
  var products = <Product>[
   /* Product(name: "Sugar", hindiName: "चीनी", pricePerUnit: 40, stock: 5000, unit: "gm", minQty: 250),
    Product(name: "Milk", hindiName: "दूध", pricePerUnit: 50, stock: 10, unit: "ltr", minQty: 1),
    Product(name: "Cheese", hindiName: "पनीर", pricePerUnit: 80, stock: 20, unit: "piece", minQty: 3),
    Product(name: "Chips", hindiName: "चिप्स", pricePerUnit: 10, stock: 50, unit: "piece", minQty: 3),
    Product(name: "Oil", hindiName: "तेल", pricePerUnit: 150, stock: 5000, unit: "ml", minQty: 500),
    Product(name: "Soap", hindiName: "साबुन", pricePerUnit: 30, stock: 40, unit: "piece", minQty: 3),
    Product(name: "Tea", hindiName: "चाय", pricePerUnit: 200, stock: 1000, unit: "gm", minQty: 250),
    Product(name: "Coffee", hindiName: "कॉफ़ी", pricePerUnit: 400, stock: 1000, unit: "gm", minQty: 250),
    Product(name: "Biscuit", hindiName: "बिस्कुट", pricePerUnit: 20, stock: 60, unit: "piece", minQty: 3),
    Product(name: "Rice", hindiName: "चावल", pricePerUnit: 60, stock: 10000, unit: "gm", minQty: 1000),*/
  ].obs;


  var cart = <Map<String, dynamic>>[].obs;


  var customers = <Customer>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadCustomers();
  }

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


}
