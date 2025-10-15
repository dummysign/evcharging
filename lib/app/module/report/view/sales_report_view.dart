import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/sales_report_controller.dart';

class SalesReportView extends GetView<SalesReportController> {
  const SalesReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sales Report")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Date Filters
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickStartDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: controller.startDateController,
                        decoration: InputDecoration(
                          labelText: "From Date",
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickEndDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: controller.endDateController,
                        decoration: InputDecoration(
                          labelText: "To Date",
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // 🔹 Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.loadSalesReport,
                  icon: Icon(Icons.refresh),
                  label: Text("Load Report"),
                ),
                ElevatedButton.icon(
                  onPressed: controller.exportToExcel,
                  icon: Icon(Icons.download),
                  label: Text("Export Excel"),
                ),
              ],
            ),

            SizedBox(height: 20),

            // 🔹 Sales Data
            Expanded(
              child: Obx(() {
                final sales = controller.salesData;
                return DataTable(
                  columns: const [
                    DataColumn(label: Text("Product")),
                    DataColumn(label: Text("Qty")),
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text("Date")),
                  ],
                  rows: sales.map((e) {
                    return DataRow(cells: [
                      DataCell(Text(e['englishName'].toString())),
                      DataCell(Text(e['quantitySold'].toString())),
                      DataCell(Text(e['totalPrice'].toStringAsFixed(2))),
                      DataCell(Text(e['date'].toString().substring(0, 10))),
                    ]);
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
