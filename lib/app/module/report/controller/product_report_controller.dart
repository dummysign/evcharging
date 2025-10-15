import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/api/data/db_helper.dart';

class ProductReportController extends GetxController {
  var productList = <Map<String, dynamic>>[].obs;
  var filteredList = <Map<String, dynamic>>[].obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    productList.assignAll(await DBHelper.getStockList());
    filteredList.assignAll(productList);
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(productList);
    } else {
      filteredList.assignAll(productList.where((p) =>
          p['englishName'].toString().toLowerCase().contains(query.toLowerCase())));
    }
  }
}
