import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ProductController extends GetxController {
  final box = GetStorage();

  // Reactive variables
  var productList = <dynamic>[].obs;
  var searchQuery = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    loadStock();
  }

  void loadStock() {
    productList.value = box.read("stockList") ?? [];
  }

  void clearFilters() {
    searchQuery.value = "";
    startDate.value = null;
    endDate.value = null;
  }

  // Computed filtered list
  List<dynamic> get filteredList {
    return productList.where((item) {
      final name = (item["englishName"] ?? "").toString().toLowerCase();
      final brand = (item["brandName"] ?? "").toString().toLowerCase();
      final dateStr = item["date"];
      final date = dateStr != null ? DateTime.tryParse(dateStr) : null;

      bool matchesSearch = name.contains(searchQuery.value.toLowerCase()) ||
          brand.contains(searchQuery.value.toLowerCase());

      bool matchesDate = true;
      if (startDate.value != null && date != null) {
        matchesDate =
            date.isAfter(startDate.value!.subtract(const Duration(days: 1)));
      }
      if (endDate.value != null && date != null) {
        matchesDate = matchesDate &&
            date.isBefore(endDate.value!.add(const Duration(days: 1)));
      }

      return matchesSearch && matchesDate;
    }).toList();
  }

  // Excel export
  Future<void> exportToExcel(List<dynamic> data, String fileKey) async {
    final excel = Excel.createExcel();
    final sheet = excel['Stock'];

    sheet.appendRow([
      TextCellValue("Date"),
      TextCellValue("Brand"),
      TextCellValue("Product"),
      TextCellValue("Qty Bought"),
      TextCellValue("Qty Left"),
      TextCellValue("Unit"),
      DoubleCellValue(0),
      DoubleCellValue(0),
      TextCellValue("Profit Type"),
      DoubleCellValue(0),
      DoubleCellValue(0),
    ]);

    for (final item in data) {
      sheet.appendRow([
        TextCellValue((item["date"] ?? "").toString().substring(0, 10)),
        TextCellValue(item["brandName"] ?? ""),
        TextCellValue(item["englishName"] ?? ""),
        DoubleCellValue((item["quantityBought"] ?? 0).toDouble()),
        DoubleCellValue((item["quantityRemaining"] ?? 0).toDouble()),
        TextCellValue(item["unitType"] ?? "kg"),
        DoubleCellValue((item["perUnitCost"] ?? 0).toDouble()),
        DoubleCellValue((item["suggestedPrice"] ?? 0).toDouble()),
        TextCellValue(item["profitType"] ?? ""),
        DoubleCellValue((item["profitValue"] ?? 0).toDouble()),
        DoubleCellValue((item["gstPercent"] ?? 0).toDouble()),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$fileKey.xlsx");
    await file.writeAsBytes(excel.encode()!);
    await OpenFilex.open(file.path);
  }

  // PDF export
  Future<void> exportToPdf(List<dynamic> data, String fileKey) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("Stock Report", style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            headers: [
              "Date",
              "Brand",
              "Product",
              "Qty",
              "Cost",
              "Sell",
              "Profit",
              "GST"
            ],
            data: data.map((item) {
              return [
                item["date"]?.toString().substring(0, 10) ?? "",
                item["brandName"] ?? "",
                item["englishName"] ?? "",
                item["quantityRemaining"].toString(),
                item["perUnitCost"].toString(),
                item["suggestedPrice"].toString(),
                "${item["profitValue"]}${item["profitType"] == "Percent" ? "%" : "₹"}",
                item["gstPercent"].toString(),
              ];
            }).toList(),
          )
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$fileKey.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFilex.open(file.path);
  }
}

