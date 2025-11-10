import 'package:get/get.dart';
import '../../../data/Customer.dart';
import '../../../data/Product.dart';

class KhataController extends GetxController {
  var products = <Product>[
   /* Product(name: "Sugar", hindiName: "चीनी", pricePerUnit: 40, stock: 5000, unit: "gm", minQty: 250),
    Product(name: "Milk", hindiName: "दूध", pricePerUnit: 50, stock: 10, unit: "ltr", minQty: 1),
    Product(name: "Cheese", hindiName: "पनीर", pricePerUnit: 80, stock: 20, unit: "piece", minQty: 3),
    Product(name: "Chips", hindiName: "चिप्स", pricePerUnit: 10, stock: 50, unit: "piece", minQty: 3),
    Product(name: "Oil", hindiName: "तेल", pricePerUnit: 150, stock: 5000, unit: "ml", minQty: 500),
    Product(name: "Soap", hindiName: "साबुन", pricePerUnit: 30, stock: 40, unit: "piece", minQty: 3),
    Product(name: "Tea", hindiName: "चाय", pricePerUnit: 200, stock: 1000, unit: "gm", minQty: 250),
    Product(name: "Coffee", hindiName: "कॉफ़ी", pricePerUnit: 400, stock: 1000, unit: "gm", minQty: 250),
    Product(name: "Biscuit", hindiName: "बिस्कुट", pricePerUnit: 20, stock: 60, unit: "piece", minQty: 3),
    Product(name: "Rice", hindiName: "चावल", pricePerUnit: 60, stock: 10000, unit: "gm", minQty: 1000),*/
  ].obs;

  var cart = <Map<String, dynamic>>[].obs;


  var customers = <Customer>[
    Customer(name: "Ramesh Kumar", hindiName: "रामेश कुमार"),
    Customer(name: "Sita Devi", hindiName: "सीता देवी"),
  ].obs;

  /*void addToKhata(Customer customer) {
    for (var item in cart) {
      customer.ledger.add({
        "productName": item['name'],
        "productHindiName": item['hindiName'],
        "qty": item['qty'],
        "unit": item['unit'],
        "price": item['price'],
        "date": DateTime.now(),
      });
    }
    cart.clear();
  }*/

  // Total price of current cart
  // double get total => cart.fold(0, (sum, item) => sum + (item['price'] as double));

  /* void sellProduct(Product product, double qty, double price) {
    if (qty < product.minQty) {
      Get.snackbar("Invalid Qty", "Quantity should be at least ${product.minQty} ${product.unit}");
      return;
    }

    if (qty <= product.stock) {
      product.stock -= qty;
      cart.add({
        "name": product.name,
        "qty": qty,
        "unit": product.unit,
        "price": price,
      });
      products.refresh();
      cart.refresh();
    } else {
      Get.snackbar("Stock Error", "Not enough stock available!");
    }
  }*/

  void sellProduct(Product product, double qty, double price) {
    /*if (qty <= product.stock) {
      product.stock -= qty;
      cart.add({
        "name": product.name,
        "hindiName": product.hindiName,
        "qty": qty,
        "unit": product.unit,
        "price": price,
        "pricePerUnit":"" ;
      });
      products.refresh();
      cart.refresh();
    } else {
      Get.snackbar("Stock Error", "Not enough stock available!");
    }*/
  }


  // Computed total
  double get total {
    double sum = 0;
    for (var item in cart) {
      sum += (item['price'] ?? 0).toDouble();
    }
    return sum;
  }

  void clearCart() {
    cart.clear();
  }
}
