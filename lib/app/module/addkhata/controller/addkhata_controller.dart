
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/api/data/db_helper.dart';

class AddKhataController extends GetxController{
  var khataList = <Map<String, dynamic>>[].obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  RxBool isLoading = false.obs;


  Future<void> createKhata() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar("Missing Info", "Please enter both name and phone number");
      return;
    }

    isLoading.value= true;

    final db = await DBHelper.database;

    // ✅ Check if khata already exists
    final existing = await db.query('khata_records', where: 'phone = ?', whereArgs: [phone]);

    if (existing.isNotEmpty) {
      Get.snackbar("Already Exists", "A khata already exists for this customer");
      isLoading.value = false;
      return;
    }

    // ✅ Create local record
    final record = {
      "customerName": name,
      "phone": phone,
      "totalDue": 0.0,
      "transactions": jsonEncode([]),
      "lastUpdated": DateTime.now().toIso8601String(),
    };

    await db.insert('khata_records', record);

    // ✅ Also save to Firebase
    final firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users')
        .doc('123')
        .collection('khata')
        .doc(phone)
        .set(record);

    Get.snackbar("Success", "Khata created successfully");

    nameController.clear();
    phoneController.clear();

    isLoading.value = false;
  }

  Future<void> loadKhatas() async {
    final data = await DBHelper.getAllKhatas();
    khataList.assignAll(data);
  }

  Future<void> addPurchase({
    required String name,
    required String phone,
    required double amount,
    required String note,
  }) async {
    await DBHelper.insertOrUpdateKhata(
        customerName: name, phone: phone, amount: amount, note: note);
    await syncToFirebase(phone);
    await loadKhatas();
  }

  Future<void> addPayment(String phone, double amount) async {
    await DBHelper.recordPayment(phone, amount);
    await syncToFirebase(phone);
    await loadKhatas();
  }

  Future<void> syncToFirebase(String phone) async {
    final db = await DBHelper.database;
    final record = await db.query('khata_records', where: 'phone = ?', whereArgs: [phone]);

    if (record.isEmpty) return;

    final data = record.first;

    final firestore = FirebaseFirestore.instance;

    // ✅ Safely parse fields
    final customerName = data['customerName']?.toString() ?? '';
    final phoneNumber = data['phone']?.toString() ?? '';
    final lastUpdated = data['lastUpdated']?.toString() ?? DateTime.now().toIso8601String();

    final totalDue = (data['totalDue'] is num)
        ? data['totalDue'] as num
        : double.tryParse(data['totalDue']?.toString() ?? '0') ?? 0.0;

    final transactionsJson = data['transactions']?.toString() ?? '[]';
    final transactions = jsonDecode(transactionsJson);

    // ✅ Sync to Firebase
    await firestore
        .collection('users')
        .doc('123')
        .collection('khata')
        .doc(phoneNumber)
        .set({
      "customerName": customerName,
      "phone": phoneNumber,
      "totalDue": totalDue,
      "transactions": transactions,
      "lastUpdated": lastUpdated,
    }, SetOptions(merge: true));
  }

}