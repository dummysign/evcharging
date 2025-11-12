import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/customerledger_controller.dart';


class  CustomerLedgerScreenState extends GetView<CustomerLedgerController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${controller.customer.name} Ledger / खाता')),
      body: Obx(() {
        final txns = controller.transactions;

        if (txns.isEmpty) {
          return const Center(
              child: Text("No transactions found / कोई लेन-देन नहीं मिला"));
        }

        return ListView.builder(
          itemCount: txns.length,
          itemBuilder: (context, index) {
            final txn = txns[index];
            final date = txn['date']?.toString().split('T').first ?? '';
            final amount = txn['amount'] ?? 0.0;
            final note = txn['note'] ?? '';
            final items = txn['items'] as List;

            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Date and Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(date,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          "₹ ${amount.toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(note, style: const TextStyle(color: Colors.grey)),

                    const Divider(),

                    // Items List
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: items.map<Widget>((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(
                                      "${item['productName']} (${item['qty']} ${item['unit']})")),
                              Text("₹ ${item['price']}"),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(16),
        child: Text(
          "Total Due: ₹ ${controller.customer.totalDue!.toStringAsFixed(2)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
    );
  }
}
