import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/Customer.dart';
import '../module/khata/controller/khata_controller.dart';

class CustomerLedgerScreen extends StatefulWidget {
  final Customer customer;

  const CustomerLedgerScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  State<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  final KhataController controller = Get.find<KhataController>();

  @override
  void initState() {
    super.initState();
    // ✅ Load data once when screen opens
  //  controller.loadCustomerTransactions(widget.customer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.customer.name} Ledger / खाता')),
      /*body: Obx(() {
      //  final txns = controller.transactions;

       *//* if (txns.isEmpty) {
          return const Center(
              child: Text("No transactions found / कोई लेन-देन नहीं मिला"));
        }*//*

        return ListView.builder(
          itemCount: txns.length,
          itemBuilder: (context, index) {
            final txn = txns[index];
            final isCredit = txn['type'] == 'credit';
            final color = isCredit ? Colors.green : Colors.red;

            return ListTile(
              leading: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: color,
              ),
              title: Text(txn['description'] ?? 'Transaction'),
              subtitle: Text(txn['date'] ?? ''),
              trailing: Text(
                "₹ ${txn['amount']}",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            );
          },
        );
      }),*/
      bottomNavigationBar: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(16),
        child: Text(
          "Total Due: ₹ ${widget.customer.totalDue!.toStringAsFixed(2)}",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
    );
  }
}
