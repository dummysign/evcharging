import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_report_controller.dart';

class ProductReportView extends GetView<ProductReportController> {
  const ProductReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Report")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Filter Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Search by product name",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (v) => controller.filterProducts(v),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 🔹 Product Data Table
            Expanded(
              child: Obx(() {
                final data = controller.filteredList;
                return DataTable(
                  columns: const [
                    DataColumn(label: Text("Product")),
                    DataColumn(label: Text("Stock")),
                    DataColumn(label: Text("Unit")),
                    DataColumn(label: Text("Last Updated")),
                  ],
                  rows: data.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item['englishName'].toString())),
                        DataCell(Text(item['quantityRemaining'].toString())),
                        DataCell(Text(item['unitType'].toString())),
                        DataCell(Text(item['date'].toString().substring(0, 10))),
                      ],
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
