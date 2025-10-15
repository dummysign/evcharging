import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/report_controller_controller.dart';

class ReportControllerView extends GetView<ReportControllerController> {
  const ReportControllerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopkeeper Dashboard"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Top Summary Cards
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _summaryCard("Total Stock", controller.totalStock.value.toString(), Colors.blue),
                  _summaryCard("Low Stock", controller.lowStockItems.value.toString(), Colors.red),
                  _summaryCard("Fast Movers", controller.fastMovers.join(", "), Colors.orange),
                ],
              )),
              SizedBox(height: 20),
        
              // 🔹 Low Stock Items Table
              _sectionTitle("Low Stock Items"),
              Obx(() => _dataTable(controller.lowStockList, ["product", "stock", "lastAdded"])),
              SizedBox(height: 20),
        
              // 🔹 Recent Sales Table
              _sectionTitle("Recent Sales"),
              Obx(() => _dataTable(controller.recentSales, ["product", "qty", "price"])),
              SizedBox(height: 20),

              // 🔹 Action Buttons for Detailed Reports (Responsive)
              LayoutBuilder(
                builder: (context, constraints) {
                  bool isWide = constraints.maxWidth > 500; // Adjust breakpoint if needed

                  return isWide
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _reportButton(
                        "Product Report",
                        Icons.inventory_2,
                            () => controller.showProductReport(context),
                      ),
                      _reportButton(
                        "Sales Report",
                        Icons.point_of_sale,
                            () => controller.showSalesReport(context),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _reportButton(
                        "Product Report",
                        Icons.inventory_2,
                            () => controller.showProductReport(context),
                      ),
                      SizedBox(height: 10),
                      _reportButton(
                        "Sales Report",
                        Icons.point_of_sale,
                            () => controller.showSalesReport(context),
                      ),
                    ],
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _reportButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      icon: Icon(icon, size: 22),
      label: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onPressed: onPressed,
    );
  }

  // 🔹 Summary Card Widget
  Widget _summaryCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Section Title
  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  // 🔹 Generic DataTable
  Widget _dataTable(List data, List<String> columns) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: columns.map((col) => DataColumn(label: Text(col))).toList(),
        rows: data.map((item) {
          return DataRow(
            cells: columns
                .map((col) => DataCell(
                Text(item[col] != null ? item[col].toString() : "-")))
                .toList(),
          );
        }).toList(),
      ),
    );
  }



  // 🔹 Show Sales Report

}

// You need to create these screens:
// 1️⃣ ProductReportView: Shows stock, batches, unit, value per product
// 2️⃣ SalesReportView: Shows all sales, with date filter (day, month, year)
