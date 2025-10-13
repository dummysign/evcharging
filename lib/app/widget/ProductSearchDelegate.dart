import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/Product.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  final List<Product> products;
  ProductSearchDelegate(this.products);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where((p) =>
    p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.hindiName.contains(query)).toList();

    return _buildProductList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = products.where((p) =>
    p.name.toLowerCase().contains(query.toLowerCase()) ||
        p.hindiName.contains(query)).toList();

    return _buildProductList(suggestions);
  }

  double _averagePrice(Product product) {
    if (product.totalStock == 0) return 0.0;
    return product.batches.fold<double>(
        0.0, (sum, b) => sum + b.pricePerUnit * b.stock) /
        product.totalStock;
  }

  Widget _buildProductList(List<Product> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return ListTile(
          title: Text("${product.name} (${product.hindiName})"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "Avg Price: ₹${_averagePrice(product).toStringAsFixed(2)}/${product.unit} | Total Stock: ${product.totalStock.toStringAsFixed(2)} ${product.unit}"),
              // Optional: show batch-level details
              if (product.batches.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: product.batches.map((b) {
                    return Text(
                      "Batch ${b.purchaseDate.toIso8601String().split('T')[0]}: ${b.stock.toStringAsFixed(2)} ${product.unit} @ ₹${b.pricePerUnit.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    );
                  }).toList(),
                ),
            ],
          ),
          onTap: () => close(context, product),
        );
      },
    );
  }
}
