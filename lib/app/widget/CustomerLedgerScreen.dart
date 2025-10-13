import 'package:evcharging/app/data/Customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomerLedgerScreen extends StatelessWidget {
  final Customer customer;
  CustomerLedgerScreen({required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${customer.name} (${customer.hindiName})"),
      ),
      body: Column(
        children: [
          // Total Khata
          Obx(() => Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Text(
              "Total Outstanding / कुल बकाया: ₹",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )),
          Divider(),

          // Ledger Entries
          Expanded(
            child: Obx(() {
              if (customer.ledger.isEmpty) {
                return Center(
                    child: Text("No entries yet / कोई लेन-देन नहीं"));
              }

              return ListView.builder(
                itemCount: customer.ledger.length,
                itemBuilder: (context, index) {
                  final entry = customer.ledger[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                          "${entry['productName']} (${entry['productHindiName']})"),
                      subtitle: Text(
                          "${entry['qty']} ${entry['unit']} - ${entry['date'] != null ? entry['date'].toString().split(" ")[0] : ""}"),
                      trailing: Text(
                          "₹${(entry['price'] ?? 0).toStringAsFixed(2)}"),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
