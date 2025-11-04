import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/api/data/db_helper.dart';
import '../../../route/app_pages.dart';

class ReportControllerController extends GetxController {
  // Top summary cards
  var totalStock = 0.0.obs;
  var totalValue = 0.0.obs;
  var lowStockItems = 0.obs;
  var fastMovers = <String>[].obs;

  // Sample data for charts
  var stockByCategory = <String, double>{}.obs;
  var salesTrend = <String, double>{}.obs;

  // Tables
  RxList<dynamic> templowStockList = <dynamic>[].obs;
  RxList<dynamic> lowStockList = <dynamic>[].obs;
  //var lowStockList = [].obs;
  var recentSales = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    totalStock.value = await DBHelper.getTotalStock();
    totalValue.value = await DBHelper.getTotalValue();
    lowStockItems.value = await DBHelper.getLowStockCount(5); // threshold = 5
    fastMovers.assignAll(await DBHelper.getFastMovers(5));
    stockByCategory.assignAll(await DBHelper.getStockByCategory());
    recentSales.assignAll(
      (await DBHelper.getRecentSales(5)).map((e) {
        return {
          "product": e["productName"],
          "qty": e["qty"],
          "price": (e["price"] as num).toDouble().toStringAsFixed(2), // ✅ rounded to 2 digits
        };
      }).toList(),
    );
    templowStockList.assignAll(await DBHelper.getTopLowStockItems());
    lowStockList.assignAll(
        templowStockList.map((e) {
          // Parse the date string from DB
          final rawDate = DateTime.parse(e["date"]);
          final formattedDate = DateFormat('dd MMM').format(rawDate); // e.g., 15 Oct
          return {
            "product": e["englishName"],
            "stock": e["quantityRemaining"],
            "lastAdded": formattedDate, // formatted day & month
          };
        }).toList(),
    );
    print("Stock in base unit: $lowStockList");
  }

  // 🔹 Show Product Report
  void showProductReport(BuildContext context) {
    Get.toNamed(Routes.PRODUCTREPORT);// Navigate to a product report screen
  }

  void showSalesReport(BuildContext context) {
    Get.toNamed(Routes.SALEREPORT); // Navigate to a sales report screen
  }
}
