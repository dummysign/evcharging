import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/Customer.dart';
import '../../../data/Product.dart';

class ShopController extends GetxController {
  final box = GetStorage();

  // Reactive product list
  var products = <Product>[].obs;

  // Cart
  var cart = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    final saved = box.read('products');
    if (saved != null) {
      products.value = (saved as List)
          .map((p) => Product.fromJson(Map<String, dynamic>.from(p)))
          .toList();
    } else {
      // If no data, initialize default products
      products.value = [
        Product(
          name: "rice",
          hindiName: "चावल",
          brandName: "baba",
          unit: "kg",
          batches: [
            ProductBatch(
                stock: 24,
                pricePerUnit: 75.83,
                purchaseDate: DateTime(2025, 10, 1)),
            ProductBatch(
                stock: 24,
                pricePerUnit: 67.50,
                purchaseDate: DateTime(2025, 11, 1)),
          ],
        ),
        Product(
          name: "Sugar",
          hindiName: "चीनी",
          brandName: "baba",
          unit: "gm",
          batches: [
            ProductBatch(stock: 5000, pricePerUnit: 40, purchaseDate: DateTime.now())
          ],
        ),
        // Add more products here...
      ];
      saveProducts();
    }
  }

  void saveProducts() {
    box.write('products', products.map((p) => p.toJson()).toList());
  }


  void sellProduct(Product product, double qty, double price, ProductBatch batch) {
    if (qty <= batch.stock) {
      batch.stock -= qty;
      cart.add({
        "product": product,
        "name": product.name,
        "batch": batch,
        "hindiName": product.hindiName,
        "qty": qty,
        "unit": product.selectedUnit,
        "price": price,
        "pricePerUnit": batch.pricePerUnit,
        "batchDate": batch.purchaseDate,
      });
      products.refresh();
      cart.refresh();
      // --- Update storage ---
      final box = GetStorage();
      List<dynamic> storedList = box.read("stockList") ?? [];

      // Find the product in storage
      final index = storedList.indexWhere((p) => p["name"] == product.name);
      if (index != -1) {
        final storedProduct = storedList[index];

        // Find the batch in storage by purchase date
        final batchIndex = (storedProduct["batches"] as List)
            .indexWhere((b) => b["purchaseDate"] == batch.purchaseDate.toIso8601String());

        if (batchIndex != -1) {
          storedProduct["batches"][batchIndex]["stock"] = batch.stock;
        }

        storedList[index] = storedProduct;
        box.write("stockList", storedList); // persist updated stock
      }
    } else {
      Get.snackbar("Stock Error", "Not enough stock available!");
    }
  }

  double getUnitFactor(String unit) {
    switch (unit) {
      case 'kg':
      case 'ltr':
        return 1.0; // base unit
      case 'gm':
      case 'ml':
        return 0.001; // 1 gm = 0.001 kg, 1 ml = 0.001 l
      case 'piece':
        return 1.0; // pieces don't need conversion
      default:
        return 1.0;
    }
  }


  // Sell product: supports multiple batches (FIFO)
 /* void sellProduct(String productName, double qty, double sellingPrice) {
    final product =
    products.firstWhereOrNull((p) => p.name == productName);

    if (product == null) {
      Get.snackbar("Error", "Product not found");
      return;
    }

    double remainingQty = qty;

    // Sort batches oldest first
    product.batches.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));

    for (var batch in product.batches) {
      if (remainingQty <= 0) break;

      double sellQty = remainingQty > batch.stock ? batch.stock : remainingQty;
      if (sellQty <= 0) continue;

      batch.stock -= sellQty;
      remainingQty -= sellQty;

      cart.add({
        "name": product.name,
        "hindiName": product.hindiName,
        "qty": sellQty,
        "unit": product.unit,
        "sellingPrice": sellingPrice,
        "purchasePrice": batch.pricePerUnit,
        "purchaseDate": batch.purchaseDate.toIso8601String(),
      });
    }

    if (remainingQty > 0) {
      Get.snackbar(
        "Stock Warning",
        "Only ${qty - remainingQty} ${product.unit} sold. Not enough stock!",
      );
    }

    products.refresh();
    cart.refresh();
    saveProducts(); // persist stock
  }*/

  void completeSale() {
    final box = GetStorage();
    List<dynamic> storedList = box.read("stockList") ?? [];

    for (var item in cart) {
      Product product = item["product"];
      ProductBatch batch = item["batch"];
      double qty = item["qty"];

      // Subtract from batch stock
      batch.stock -= qty;

      // Update storage
      final index = storedList.indexWhere((p) =>
      p["englishName"] == product.name &&
          p["brandName"] == product.brandName
      );
     // final index = storedList.indexWhere((p) => p["name"] == product.name);
      if (index != -1) {
        final storedProduct = storedList[index];
        final batchIndex = (storedProduct["batches"] as List)
            .indexWhere((b) => b["purchaseDate"] == batch.purchaseDate.toIso8601String());
        if (batchIndex != -1) {
          storedProduct["batches"][batchIndex]["stock"] = batch.stock;
        }
        storedList[index] = storedProduct;
      }
    }

    box.write("stockList", storedList);

    // Clear cart
    cart.clear();

    // Refresh product list in UI
    products.refresh();
  }


  // Cart total
  double get total =>
      cart.fold(0, (sum, item) => sum + ((item['sellingPrice'] ?? 0) * (item['qty'] ?? 0)));

  void clearCart() => cart.clear();

  var customers = <Customer>[
    Customer(name: "Ramesh Kumar", hindiName: "रामेश कुमार"), Customer(name: "Sita Devi", hindiName: "सीता देवी"), ].obs; void addToKhata(Customer customer) { for (var item in cart)
    { customer.ledger.add({ "productName": item['name'], "productHindiName": item['hindiName'], "qty": item['qty'], "unit": item['unit'], "price": item['price'], "date": DateTime.now(), }); }
  cart.clear(); }
}
