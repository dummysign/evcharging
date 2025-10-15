import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../../common/api/data/db_helper.dart';

class AddProductController extends GetxController {
  var productNameEnglish = ''.obs;
  var productNameHindi = ''.obs;
  var brandName = ''.obs;
  var quantity = 0.0.obs;
  var totalAmountPaid = 0.0.obs;
  var perKgCost = 0.0.obs;
  var isLooseSell = false.obs;
  var profitType = 'Percent'.obs; // 'Percent' or 'Amount'
  var profitValue = 0.0.obs;
  var gstPercent = 0.0.obs;
  var suggestedPrice = 0.0.obs;
  var unitType = 'kg'.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    GetStorage.init();
  }

  void calculateSuggestedPrice() {
    double qty = quantity.value;
    double total = totalAmountPaid.value;

    if (qty > 0 && total > 0) {
      // 🧠 Normalize quantity based on selected unit
      double normalizedQty = qty;

      // Example: "g", "kg", "ml", "ltr"
      if (unitType.value == 'g') {
        normalizedQty = qty / 1000; // grams → kg
      } else if (unitType.value == 'ml') {
        normalizedQty = qty / 1000; // ml → litre
      } else if (unitType.value == 'kg' || unitType.value == 'ltr') {
        normalizedQty = qty; // already in base unit
      }

      // 💰 Calculate per-unit cost
      perKgCost.value = total / normalizedQty;

      // 📈 Calculate profit
      double profit = (profitType.value == 'Percent')
          ? perKgCost.value * (profitValue.value / 100)
          : profitValue.value;

      // 🧾 Calculate GST
      double gst = perKgCost.value * (gstPercent.value / 100);

      // 🧮 Suggested Price
      suggestedPrice.value = perKgCost.value + profit + gst;
    } else {
      suggestedPrice.value = 0;
    }
  }


  Future<void> saveProduct() async {
    final now = DateTime.now();
    final monthKey = DateFormat('yyyy_MM').format(now); // e.g. 2025_10

    final batchId =
        "${productNameEnglish.value}_${DateFormat('yyyyMMdd_HHmm').format(now)}";

    final newBatch = {
      "batchId": batchId,
      "englishName": productNameEnglish.value.trim(),
      "hindiName": productNameHindi.value.trim(),
      "brandName": brandName.value.trim(),
      "unitType": unitType.value,
      "quantityBought": quantity.value,
      "quantityRemaining": quantity.value,
      "totalPaid": totalAmountPaid.value,
      "perUnitCost": perKgCost.value,
      "profitType": profitType.value,
      "profitValue": profitValue.value,
      "gstPercent": gstPercent.value,
      "suggestedPrice": suggestedPrice.value,
      "isLoose": isLooseSell.value ? 1 : 0, // SQLite doesn’t have boolean type
      "date": now.toIso8601String(),
      "monthKey": monthKey,
    };

    // Insert into monthly product table
    await DBHelper.insert('product_batches', newBatch);

    // Insert into global stock list
    await DBHelper.insert('stock_list', newBatch);
  }


 /* Future<void> saveProduct() async {
    final now = DateTime.now();
    final monthKey = DateFormat('yyyy_MM').format(now); // e.g. 2025_10
    final fileKey = "products_$monthKey";

    // Read the existing product batch list
    List<dynamic> productList = box.read(fileKey) ?? [];

    // Create a unique batch ID (helps identify stock batches later)
    final batchId =
        "${productNameEnglish.value}_${DateFormat('yyyyMMdd_HHmm').format(now)}";

    // Each new purchase creates a new batch entry
    final newBatch = {
      "batchId": batchId,
      "englishName": productNameEnglish.value.trim(),
      "hindiName": productNameHindi.value.trim(),
      "brandName": brandName.value.trim(), // optional if you add a brand field
      "unitType": unitType.value, // 'kg', 'g', 'ltr', 'ml', 'pcs'
      "quantityBought": quantity.value,
      "quantityRemaining": quantity.value, // starts full
      "totalPaid": totalAmountPaid.value,
      "perUnitCost": perKgCost.value,
      "profitType": profitType.value,
      "profitValue": profitValue.value,
      "gstPercent": gstPercent.value,
      "suggestedPrice": suggestedPrice.value,
      "isLoose": isLooseSell.value,
      "date": now.toIso8601String(),
    };

    // Add batch to list
    productList.add(newBatch);

    // Save updated batch list
    await box.write(fileKey, productList);

    // Optional: also keep a global stock list (to see all batches)
    List<dynamic> stockList = box.read("stockList") ?? [];
    stockList.add(newBatch);
    await box.write("stockList", stockList);
  }*/

}