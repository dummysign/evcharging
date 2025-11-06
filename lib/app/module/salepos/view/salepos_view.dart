import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/Customer.dart';
import '../../../data/Product.dart';
import '../../../widget/CustomerSearchDelegate.dart';
import '../../../widget/ProductSearchDelegate.dart';
import '../controller/salepos_controller.dart';

class ShopkeeperScreen extends GetView<ShopController> {
  const ShopkeeperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shopkeeper App ")),
      body: SafeArea(
        child: Column(
          children: [
            // --- Product Selection Dropdown ---
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  Product? selectedProduct = await showSearch<Product?>(
                    context: context,
                    delegate: ProductSearchDelegate(controller.products),
                  );
                  if (selectedProduct != null) {
                    _openDialog(selectedProduct, controller);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Product", style: TextStyle(fontSize: 16)),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            ),

            Divider(),
            Text("Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // --- Cart Items ---
            Expanded(
              child: Obx(() {
                if (controller.cart.isEmpty) {
                  return Center(
                    child: Text(
                      "Cart is empty",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: controller.cart.length,
                  itemBuilder: (context, index) {
                    final item = controller.cart[index];


                    // Safe values
                    double qty = (item['qty'] ?? 0).toDouble();
                    double pricePerUnit = (item['pricePerUnit'] ?? 0).toDouble();
                    String unit = item['unit'] ?? "";
                    double price = item['price'] ;//(unit == "pcs" ? qty : qty ) * pricePerUnit;
                    item['price'] = price;

                   /* double qty = (item['qty'] ?? 0).toDouble();
                    double pricePerUnit = (item['pricePerUnit'] ?? 0).toDouble();
                    String unit = item['unit'] ?? "";
                    double price = (qty / (unit == "piece" ? 1 : 1000)) * pricePerUnit;*/

                    // Update price in item map safely
                 //   item['price'] = price;

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Product Info
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item['name'] ?? ''} (${item['hindiName'] ?? ''})",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${qty.toStringAsFixed(2)} $unit",
                                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                ),
                              ],
                            ),

                            // Qty Adjust & Remove
                            Row(
                              children: [
                                // Decrement
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () {
                                    double newQty = qty - 1;
                                    if (newQty >= 1) { // or item['minQty'] if needed
                                      item['qty'] = newQty;
                                      item['price'] = (newQty / (unit == "piece" ? 1 : 1000)) * pricePerUnit;
                                      controller.cart.refresh();
                                    }
                                  },
                                ),

                                // Increment
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline, color: Colors.green),
                                  onPressed: () {
                                    double newQty = qty + 1;
                                    item['qty'] = newQty;
                                    item['price'] = (newQty / (unit == "piece" ? 1 : 1000)) * pricePerUnit;
                                    controller.cart.refresh();
                                  },
                                ),

                                // Remove
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.grey[800]),
                                  onPressed: () {
                                    controller.cart.removeAt(index);
                                    controller.cart.refresh();
                                  },
                                ),
                              ],
                            ),

                            // Price
                            Text(
                              "₹${price.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            Divider(thickness: 1),

// --- Cart Total + Pay Button ---
            Obx(() => Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "₹${controller.total.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),

                  // Buttons
                  Row(
                    children: [
                      // Add to Khata
                      ElevatedButton.icon(
                        onPressed: controller.cart.isEmpty
                            ? null
                            : () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) {
                              return SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Choose Payment Option / भुगतान विकल्प चुनें",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total / कुल: ",
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "₹${controller.total.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                
                                      // Add to Khata Button
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          // Show customer selection
                                          Customer? selectedCustomer = await showSearch<Customer?>(
                                            context: context,
                                            delegate: CustomerSearchDelegate(controller.customers),
                                          );
                                          if (selectedCustomer != null) {
                                            controller.addToKhata(selectedCustomer);
                                            Get.snackbar(
                                              "Khata Updated / खाता अपडेट हुआ",
                                              "Added items to ${selectedCustomer.name}'s khata",
                                            );
                                            Navigator.pop(context); // Close bottom sheet
                                          }
                                        },
                                        icon: Icon(Icons.book),
                                        label: Text("Add to Khata / खाता में जोड़ें"),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(double.infinity, 50),
                                          backgroundColor: Colors.orange,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                
                                      // Cash Payment / Done Button
                                      ElevatedButton.icon(
                                        onPressed: () {

                                          controller.completeSale();
                                          Get.snackbar(
                                            "Payment / भुगतान",
                                            "Processing payment of ₹${controller.total.toStringAsFixed(2)}",
                                          );
                                        //  controller.clearCart();
                                          Navigator.pop(context); // Close bottom sheet
                                        },
                                        icon: Icon(Icons.payment),
                                        label: Text("Done / Cash Payment"),
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(double.infinity, 50),
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.payment),
                        label: Text("Pay"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            )),

          ],
        ),
      ),
    );
  }

  void _openDialog(Product product, ShopController controller) {
    String input = "";
    bool isQtyMode = true;
    double? calculatedQty;
    double? calculatedPrice;
    ProductBatch? selectedBatch = product.batches.isNotEmpty ? product.batches.first : null;

    // Helper: get conversion factor based on selected unit
    double getUnitFactor(String unit) {
      switch (unit) {
        case 'kg':
        case 'ltr':
          return 1.0;
        case 'gm':
        case 'ml':
          return 0.001;
        case 'piece':
          return 1.0;
        case 'pcs':
          return 1.0;
        default:
          return 1.0;
      }
    }

    // Compute average price for selected batch
    double getAveragePrice() {
      if (selectedBatch == null || selectedBatch!.stock == 0) return 0.0;
      return selectedBatch!.pricePerUnit;
    }

    // Total stock in selected batch (base unit)
    double getBatchStock() => selectedBatch?.stock ?? 0;

    Get.bottomSheet(
      SafeArea(
        child: StatefulBuilder(
          builder: (context, setStateDialog) {
            void calculate() {
              if (input.isEmpty) {
                calculatedQty = null;
                calculatedPrice = null;
                return;
              }

              double value = double.tryParse(input) ?? 0;
              double factor = getUnitFactor(product.selectedUnit);
              double avgPrice = getAveragePrice();

              if (isQtyMode) {
                calculatedQty = value;
                calculatedPrice = calculatedQty! * factor * avgPrice;
              } else {
                calculatedPrice = value;
                calculatedQty = calculatedPrice! / (avgPrice * factor);
              }

              setStateDialog(() {});
            }

            void addDigit(String digit) {
              input += digit;
              calculate();
            }

            void clearInput() {
              input = "";
              calculatedQty = null;
              calculatedPrice = null;
              setStateDialog(() {});
            }

            void deleteLast() {
              if (input.isNotEmpty) {
                input = input.substring(0, input.length - 1);
                calculate();
              }
            }

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Sell ${product.name}",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),

                    // Unit selection dropdown
                    Row(
                      children: [
                        Text("Unit: "),
                        DropdownButton<String>(
                          value: product.selectedUnit,
                          items: ['kg','gm','ltr','ml','piece','pcs'].map((u) =>
                              DropdownMenuItem(value: u, child: Text(u))
                          ).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              product.selectedUnit = val;
                              clearInput();
                            }
                          },
                        ),
                      ],
                    ),

                    // Batch selection dropdown
                    Row(
                      children: [
                        Text("Batch: "),
                        DropdownButton<ProductBatch>(
                          value: selectedBatch,
                          items: product.batches.map((b) => DropdownMenuItem(
                            value: b,
                            child: Text("${b.purchaseDate.toIso8601String().split('T')[0]} | Stock: ${b.stock.toStringAsFixed(2)} ${product.unit} | Stock: ${b.stock.toStringAsFixed(2)} ${product.unit} | ₹${b.pricePerUnit.toStringAsFixed(2)}"),
                          )).toList(),
                          onChanged: (b) {
                            selectedBatch = b;
                            clearInput();
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Qty/Price toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: Text("Qty (${product.selectedUnit})"),
                          selected: isQtyMode,
                          onSelected: (val) {
                            isQtyMode = true;
                            clearInput();
                          },
                        ),
                        SizedBox(width: 8),
                        ChoiceChip(
                          label: Text("Price (₹)"),
                          selected: !isQtyMode,
                          onSelected: (val) {
                            isQtyMode = false;
                            clearInput();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Input display
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            input.isEmpty
                                ? "Enter ${isQtyMode ? 'Qty' : 'Price'}"
                                : input,
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 8),
                          if (calculatedQty != null && calculatedPrice != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "Qty: ${calculatedQty!.toStringAsFixed(2)} ${product.selectedUnit}"),
                                Text(
                                    "Price: ₹${calculatedPrice!.toStringAsFixed(2)}"),
                                Text(
                                  "Remaining: ${(getBatchStock() - calculatedQty! * getUnitFactor(product.selectedUnit)).toStringAsFixed(2)} ${product.selectedUnit}",
                                  style: TextStyle(
                                    color: (getBatchStock() - calculatedQty! * getUnitFactor(product.selectedUnit) < 0)
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Keypad
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 12,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2),
                      itemBuilder: (context, index) {
                        if (index < 9) {
                          String digit = "${index + 1}";
                          return ElevatedButton(
                            onPressed: () => addDigit(digit),
                            child: Text(digit, style: TextStyle(fontSize: 22)),
                          );
                        } else if (index == 9) {
                          return ElevatedButton(
                            onPressed: clearInput,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            child: Text("C",
                                style: TextStyle(fontSize: 20, color: Colors.white)),
                          );
                        } else if (index == 10) {
                          return ElevatedButton(
                            onPressed: () => addDigit("0"),
                            child: Text("0", style: TextStyle(fontSize: 22)),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: deleteLast,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            child: Icon(Icons.backspace, color: Colors.white),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 12),

                    // Done button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (calculatedQty != null &&
                              calculatedPrice != null &&
                              calculatedQty! * getUnitFactor(product.selectedUnit) <= getBatchStock()) {
                            controller.sellProduct(
                                product, calculatedQty!, calculatedPrice!, selectedBatch!,product.selectedUnit);
                            Navigator.of(context).pop();
                          } else {
                            Get.snackbar(
                                "Stock Error", "Not enough stock available!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text("Done",
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      isScrollControlled: true,
    );
  }









}