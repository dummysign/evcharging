

import 'dart:convert';

import 'package:get/get.dart';

import '../../../../common/api/data/db_helper.dart';
import '../../../data/Customer.dart';

class CustomerLedgerController extends GetxController{
  var transactions = <Map<String, dynamic>>[].obs;
  late Customer customer;


  @override
  void onInit() {
    super.onInit();
    customer = Get.arguments;
    loadCustomerTransactions(customer);
  }

  Future<void> loadCustomerTransactions(Customer customer) async {
    transactions.clear();
    try {
      final db = await DBHelper.database;
      // Find this specific customer by phone or name
      final result = await db.query(
        'khata_records',
        where: 'phone = ?',
        whereArgs: [customer.phone],
      );

      if (result.isNotEmpty) {
        final data = result.first;
        final rawTx = data['transactions'];
        final txnList = jsonDecode(rawTx is String ? rawTx : rawTx.toString());

        // Convert to list of maps
        final parsedTxns = (txnList as List).map((e) {
          return {
            'date': e['date'] ?? '',
            'amount': e['amount'] ?? 0,
            'note': e['note'] ?? '',
            'items': e['items'] ?? [],
            'paid': e['paid'] ?? false,
          };
        }).toList();

        transactions.assignAll(parsedTxns);
        print("✅ Loaded ${transactions.length} transactions for ${customer.name}");
      } else {
        print("⚠️ No local record found for ${customer.name}");
      }
    } catch (e) {
      print("❌ Error loading transactions: $e");
    }
  }
}