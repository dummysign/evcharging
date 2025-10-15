import 'dart:convert';

class Product {
  String name;
  String hindiName;
  String brandName;
  String unit; // default unit
  String selectedUnit; // currently selected unit in UI
  List<ProductBatch> batches;

  Product({
    required this.name,
    required this.hindiName,
    required this.brandName,
    required this.unit,
    required this.batches,
    String? selectedUnit, // optional, defaults to unit
  }) :  selectedUnit = unit;

  double get totalStock => batches.fold(0, (sum, b) => sum + b.stock);

  Map<String, dynamic> toJson() => {
    "name": name,
    "hindiName": hindiName,
    "brandName": brandName,
    "unit": unit,
    "selectedUnit": selectedUnit, // save selected unit
    "batches": batches.map((b) => b.toJson()).toList(),
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json["name"],
    hindiName: json["hindiName"],
    brandName: json["brandName"],
    unit: json["unit"],
    selectedUnit: json["selectedUnit"], // restore selected unit
    batches: (json["batches"] as List)
        .map((b) => ProductBatch.fromJson(b))
        .toList(),
  );
}


class ProductBatch {
  String batchid;
  double stock;
  double pricePerUnit;
  DateTime purchaseDate;

  ProductBatch({
    required this.batchid,
    required this.stock,
    required this.pricePerUnit,
    required this.purchaseDate,
  });

  Map<String, dynamic> toJson() => {
    "batchid": batchid,
    "stock": stock,
    "pricePerUnit": pricePerUnit,
    "purchaseDate": purchaseDate.toIso8601String(),
  };

  factory ProductBatch.fromJson(Map<String, dynamic> json) => ProductBatch(
    batchid: (json["batchid"]),
    stock: (json["stock"] as num).toDouble(),
    pricePerUnit: (json["pricePerUnit"] as num).toDouble(),
    purchaseDate: DateTime.parse(json["purchaseDate"]),
  );
}
