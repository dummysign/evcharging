import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/addproduct_controller.dart';

class AddProductScreen extends GetView<AddProductController> {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              icon: const Icon(Icons.list_alt),
              onPressed: () => () //Get.to(() => ProductListScreen()),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Obx(
                        () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🛒 Product Entry',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),
        
                        // 🏷️ English + Hindi Name
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: "Name (Eng)",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) =>
                                controller.productNameEnglish.value = v,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: "नाम (Hindi)",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) =>
                                controller.productNameHindi.value = v,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
        
                        // 🧮 Quantity + Unit + Total
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Quantity",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) {
                                  controller.quantity.value =
                                      double.tryParse(v) ?? 0;
                                  controller.calculateSuggestedPrice();
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Total ₹",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) {
                                  controller.totalAmountPaid.value =
                                      double.tryParse(v) ?? 0;
                                  controller.calculateSuggestedPrice();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: "Brand",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) {
                                  controller.brandName.value =v;
                                  //controller.calculateSuggestedPrice();
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 1,
                              child: DropdownButtonFormField<String>(
                                value: controller.unitType.value,
                                decoration: const InputDecoration(
                                  labelText: "Unit",
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'kg', child: Text("Kg")),
                                  DropdownMenuItem(
                                      value: 'g', child: Text("Gram")),
                                  DropdownMenuItem(
                                      value: 'ltr', child: Text("Litre")),
                                  DropdownMenuItem(
                                      value: 'ml', child: Text("ML")),
                                  DropdownMenuItem(
                                      value: 'pcs', child: Text("Pieces")),
                                ],
                                onChanged: (val) {
                                  controller.unitType.value = val!;
                                  controller.calculateSuggestedPrice();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
        
                        // 💰 Profit and Type
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Profit",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) {
                                  controller.profitValue.value =
                                      double.tryParse(v) ?? 0;
                                  controller.calculateSuggestedPrice();
                                },
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: controller.profitType.value,
                                decoration: const InputDecoration(
                                  labelText: "Type",
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                      value: 'Percent', child: Text("%")),
                                  DropdownMenuItem(
                                      value: 'Amount', child: Text("₹")),
                                ],
                                onChanged: (val) {
                                  controller.profitType.value = val!;
                                  controller.calculateSuggestedPrice();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
        
                        // 🧾 GST Input
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "GST (%)",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (v) {
                            controller.gstPercent.value =
                                double.tryParse(v) ?? 0;
                            controller.calculateSuggestedPrice();
                          },
                        ),
                        const SizedBox(height: 8),
        
                        // 🧺 Loose Sell
                        SwitchListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text("Sold Loosely?"),
                          value: controller.isLooseSell.value,
                          onChanged: (v) => controller.isLooseSell.value = v,
                        ),
                        const Divider(),
        
                        // 💹 Display Summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Cost: ₹${controller.perKgCost.value.toStringAsFixed(2)}"),
                                Text(
                                    "Profit: ${controller.profitValue.value}${controller.profitType.value == 'Percent' ? '%' : '₹'}"),
                                Text("GST: ${controller.gstPercent.value}%"),
                              ],
                            ),
                            Text(
                              "Sell ₹${controller.suggestedPrice.value.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
        
                        // 💾 Save Button
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Save Product"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(double.infinity, 40),
                          ),
                          onPressed: () async {
                            await controller.saveProduct();
                            Get.snackbar(
                              "Saved",
                              "${controller.productNameEnglish.value} added!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.shade100,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
