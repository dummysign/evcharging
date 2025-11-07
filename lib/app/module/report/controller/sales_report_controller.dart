import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/api/data/db_helper.dart';

class SalesReportController extends GetxController {
  var salesData = <Map<String, dynamic>>[].obs;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  void onInit() {
    super.onInit();
    startDate = DateTime.now();
    endDate = DateTime.now();
    Future.delayed(Duration.zero, () {
      loadSalesReport();
    });
    //loadSalesReport();
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      startDate = picked;
      startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      endDate = picked;
      endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> loadSalesReport() async {


    if (startDate == null || endDate == null) return;

    final Map<String, Map<String, dynamic>> groupedSales = {};


    // ✅ Step 1: Check Internet Connection
    //final connectivityResult = await Connectivity().checkConnectivity();
   // final isOnline = connectivityResult != ConnectivityResult.none;

    List<Map<String, dynamic>> rawSales = [];
    final isOnline = true;
    if (isOnline) {
      print("🌐 Fetching sales data from Firebase...");

      final firestore = FirebaseFirestore.instance;
      final userRef = firestore.collection('users').doc('123');

      // ✅ Format the date exactly as saved in Firestore (yyyy-MM-dd)
      final startStr = DateFormat('yyyy-MM-dd').format(startDate!);
      final endStr = DateFormat('yyyy-MM-dd').format(endDate!);

      // ✅ Fetch data from subcollection `users/123/sales`
      final querySnapshot = await userRef
          .collection('sales')
          .where('date', isGreaterThanOrEqualTo: startStr)
          .where('date', isLessThanOrEqualTo: endStr)
          .get();

      rawSales = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'saleId': doc.id,
          'customerName': data['customerName'] ?? '',
          'paymentMode': data['paymentMode'] ?? '',
          'totalAmount': (data['totalAmount'] is num)
              ? data['totalAmount']
              : double.tryParse(data['totalAmount']?.toString() ?? '0') ?? 0.0,
          'date': data['date'] ?? '',
          'items': jsonEncode(data['items'] ?? []), // keep same JSON format as local DB
        };
      }).toList();

      print("✅ Loaded ${rawSales.length} sales from Firebase");
    } else {
      print("📴 Offline — fetching data from local database...");
      rawSales = await DBHelper.getSalesByDateRange(startDate!, endDate!);
      print("✅ Loaded ${rawSales.length} sales from local DB");
    }

    //final rawSales = await DBHelper.getSalesByDateRange(startDate!, endDate!);

    // Group sales by saleId (assuming each sale/bill has same saleId)


    /*for (var row in rawSales) {
      final saleId = row['saleId']?.toString() ?? 'unknown';
      final customerName = row['customerName']?.toString() ?? 'N/A';
      final paymentMode = row['paymentMode']?.toString() ?? 'Cash';
      final date = row['date']?.toString() ?? DateTime.now().toIso8601String();

      // ✅ Convert numeric values safely
      final totalAmount =
      (row['totalAmount'] is num) ? row['totalAmount'] as num :
      double.tryParse(row['totalAmount']?.toString() ?? '0') ?? 0.0;

      final item = {
        'productName': row['productName']?.toString(),
        'qty': (row['quantitySold'] is num)
            ? row['quantitySold']
            : double.tryParse(row['quantitySold']?.toString() ?? '0') ?? 0.0,
        'unit': row['unit']?.toString(),
        'price': (row['totalPrice'] is num)
            ? row['totalPrice']
            : double.tryParse(row['totalPrice']?.toString() ?? '0') ?? 0.0,
      };

      if (groupedSales.containsKey(saleId)) {
        // ✅ Ensure consistent numeric type before addition
        final existingAmount =
        (groupedSales[saleId]!['totalAmount'] is num)
            ? groupedSales[saleId]!['totalAmount']
            : double.tryParse(groupedSales[saleId]!['totalAmount'].toString()) ?? 0.0;

        groupedSales[saleId]!['totalAmount'] = existingAmount + totalAmount;
        groupedSales[saleId]!['items'].add(item);
      } else {
        groupedSales[saleId] = {
          'customerName': customerName,
          'paymentMode': paymentMode,
          'date': date,
          'totalAmount': totalAmount,
          'items': [item],
        };
      }
    }*/


    for (var row in rawSales) {
      final saleId = row['saleId']?.toString() ?? 'unknown';
      final customerName = row['customerName']?.toString() ?? 'N/A';
      final paymentMode = row['paymentMode']?.toString() ?? 'Cash';
      final date = row['date']?.toString() ?? DateTime.now().toIso8601String();

      // ✅ Safely parse numeric total amount
      final totalAmount =
      (row['totalAmount'] is num)
          ? row['totalAmount']
          : double.tryParse(row['totalAmount']?.toString() ?? '0') ?? 0.0;

      // ✅ Decode items JSON string from database
      List<dynamic> decodedItems = [];
      try {
        decodedItems = jsonDecode(row['items'] ?? '[]');
      } catch (e) {
        print('❌ JSON Decode Error: $e');
      }

      // ✅ Add or merge sale
      if (groupedSales.containsKey(saleId)) {
        final existingAmount =
        (groupedSales[saleId]!['totalAmount'] is num)
            ? groupedSales[saleId]!['totalAmount']
            : double.tryParse(groupedSales[saleId]!['totalAmount'].toString()) ?? 0.0;

        groupedSales[saleId]!['totalAmount'] = existingAmount + totalAmount;
        groupedSales[saleId]!['items'].addAll(decodedItems);
      } else {
        groupedSales[saleId] = {
          'customerName': customerName,
          'paymentMode': paymentMode,
          'date': date,
          'totalAmount': totalAmount,
          'items': decodedItems,
        };
      }
    }

    // Convert to list for your view
    salesData.assignAll(groupedSales.values.toList());

    if (salesData.isEmpty) {
      Get.snackbar("No Records", "No sales found for selected date range");
    }
  }




  Future<void> exportToExcel() async {
    // implement Excel export using openpyxl or excel package
    Get.snackbar("Export", "Excel export coming soon!");
  }

  void showSaleDetailsDialog(BuildContext context, Map<String, dynamic> sale) {
    final items = sale['items'] as List<dynamic>;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Sale Details - ${sale['customerName']}"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Payment: ${sale['paymentMode']}"),
              Text("Total: ₹${sale['totalAmount']}"),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item['productName']),
                      subtitle: Text("${item['qty']} ${item['unit']}"),
                      trailing: Text("₹${item['price']}"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}
