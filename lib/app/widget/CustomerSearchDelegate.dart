import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/Customer.dart';

class CustomerSearchDelegate extends SearchDelegate<Customer?> {
  final RxList<Customer> customers;
  CustomerSearchDelegate(this.customers);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: () => query = "", icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () => close(context, null), icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = customers.where((c) =>
    c.name.toLowerCase().contains(query.toLowerCase()) ||
        c.hindiName.contains(query)).toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (_, index) {
        final customer = results[index];
        return ListTile(
          title: Text("${customer.name} (${customer.hindiName})"),
          onTap: () => close(context, customer),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}