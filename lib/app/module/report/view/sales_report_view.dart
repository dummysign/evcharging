import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/sales_report_controller.dart';

class SalesReportView extends GetView<SalesReportController> {
  const SalesReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                        decoration: const InputDecoration(
                          labelText: "From Date",
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.pickEndDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: controller.endDateController,
                        decoration: const InputDecoration(
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

            const SizedBox(height: 20),

            // 🔹 Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.loadSalesReport,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Load Report"),
                ),
                ElevatedButton.icon(
                  onPressed: controller.exportToExcel,
                  icon: const Icon(Icons.download),
                  label: const Text("Export Excel"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Sales Data Table
            Expanded(
              child: Obx(() {
                final sales = controller.salesData;
                if (sales.isEmpty) {
                  return const Center(child: Text("No sales found"));
                }



                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmallScreen = constraints.maxWidth < 600;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: isSmallScreen ? constraints.maxWidth : 600,
                          ),
                          child: DataTable(
                            columnSpacing: isSmallScreen ? 10 : 20,
                            headingRowColor:
                            WidgetStateProperty.all(Colors.blueGrey.shade50),
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            columns: const [
                              DataColumn(label: Text("Customer", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Total ₹", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Mode", style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold))),
                            ],

                            rows: sales.map((sale) {
                              String dateText = sale['date'].toString();
                              try {
                                dateText = DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(DateTime.parse(sale['date']));
                              } catch (_) {}
                              // ✅ Parse totalAmount safely
                              final totalAmountValue = sale['totalAmount'];
                              final totalAmount = (totalAmountValue is num)
                                  ? totalAmountValue
                                  : double.tryParse(totalAmountValue?.toString() ?? "0") ?? 0.0;
                              return DataRow(
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: isSmallScreen ? 100 : 150,
                                      child: Text(
                                        sale['customerName'].toString(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  DataCell(Text("₹${totalAmount.toStringAsFixed(2)}")),
                                  DataCell(Text(sale['paymentMode'].toString())),
                                  DataCell(Text(dateText)),
                                ],
                                onSelectChanged: (_) {
                                  controller.showSaleDetailsDialog(context, sale);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

          ],
        ),
      ),
    );
  }
}
