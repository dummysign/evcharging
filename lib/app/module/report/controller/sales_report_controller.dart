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
    salesData.assignAll(await DBHelper.getSalesByDateRange(startDate!, endDate!));
  }

  Future<void> exportToExcel() async {
    // implement Excel export using openpyxl or excel package
    Get.snackbar("Export", "Excel export coming soon!");
  }
}
