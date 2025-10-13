import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import '../controller/product_controller.dart';

class ProductListScreen extends GetView<ProductController> {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("📦 Stock / Purchase History"),
        backgroundColor: Colors.blueAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'excel') {
                c.exportToExcel(c.filteredList, "stockList");
              } else if (value == 'pdf') {
                c.exportToPdf(c.filteredList, "stockList");
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'excel',
                child: Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.green),
                    SizedBox(width: 8),
                    Text("Export to Excel"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Export to PDF"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        final list = c.filteredList;

        return Column(
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by product or brand...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (v) => c.searchQuery.value = v,
              ),
            ),

            // 📅 Date filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(c.startDate.value == null
                          ? "From Date"
                          : DateFormat('dd MMM yyyy')
                          .format(c.startDate.value!)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: c.startDate.value ?? DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) c.startDate.value = picked;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: Text(c.endDate.value == null
                          ? "To Date"
                          : DateFormat('dd MMM yyyy')
                          .format(c.endDate.value!)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: c.endDate.value ?? DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) c.endDate.value = picked;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    tooltip: "Clear filters",
                    onPressed: c.clearFilters,
                  )
                ],
              ),
            ),
            const Divider(height: 1),

            // 📊 Stock list
            Expanded(
              child: list.isEmpty
                  ? const Center(
                child: Text(
                  "No matching records found.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final item = list[i];
                  final englishName = item["englishName"] ?? "Unknown";
                  final hindiName = item["hindiName"] ?? "";
                  final brandName = item["brandName"] ?? "-";
                  final qtyBought =
                  (item["quantityBought"] ?? 0).toDouble();
                  final qtyRemaining =
                  (item["quantityRemaining"] ?? 0).toDouble();
                  final perUnitCost =
                  (item["perUnitCost"] ?? 0).toDouble();
                  final sellPrice =
                  (item["suggestedPrice"] ?? 0).toDouble();
                  final profitValue = item["profitValue"] ?? 0;
                  final profitType = item["profitType"] ?? "₹";
                  final gst = item["gstPercent"] ?? 0;
                  final unitType = item["unitType"] ?? "kg";
                  final date = item["date"] ?? "";

                  final isLowStock = qtyRemaining < 10;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    elevation: 2,
                    color: isLowStock
                        ? Colors.red.shade50
                        : Colors.grey.shade50,
                    child: ListTile(
                      title: Text(
                        "$englishName ($hindiName)",
                        style:
                        const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Brand: $brandName\n"
                            "Qty: $qtyRemaining / $qtyBought $unitType\n"
                            "Cost ₹${perUnitCost.toStringAsFixed(2)} | Sell ₹${sellPrice.toStringAsFixed(2)}\n"
                            "Profit: $profitValue${profitType == "Percent" ? "%" : "₹"} | GST: $gst%",
                        style: TextStyle(
                          fontSize: 13,
                          color: isLowStock
                              ? Colors.red.shade700
                              : Colors.black,
                        ),
                      ),
                      trailing: Text(
                        date.toString().substring(0, 10),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
