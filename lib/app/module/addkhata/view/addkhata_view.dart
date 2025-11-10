
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../controller/addkhata_controller.dart';

class AddKhataView extends GetView<AddKhataController>{
  const AddKhataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Khata"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: "Customer Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : controller.createKhata,
                icon: const Icon(Icons.add),
                label: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Khata"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

void _showAddDialog(BuildContext context,AddKhataController controller) {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Add Purchase"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: "Customer Name")),
          TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),
          TextField(controller: amountController, decoration: const InputDecoration(labelText: "Amount"), keyboardType: TextInputType.number),
          TextField(controller: noteController, decoration: const InputDecoration(labelText: "Note")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            await controller.addPurchase(
              name: nameController.text.trim(),
              phone: phoneController.text.trim(),
              amount: double.tryParse(amountController.text) ?? 0.0,
              note: noteController.text.trim(),
            );
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}

void _showDetails(BuildContext context, Map<String, dynamic> khata,AddKhataController controller) {
  final transactions = jsonDecode(khata['transactions']) as List;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            khata['customerName'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Phone: ${khata['phone']}"),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (_, i) {
                final t = transactions[i];
                final isPayment = (t['paid'] ?? false);
                return ListTile(
                  leading: Icon(isPayment ? Icons.payment : Icons.shopping_cart,
                      color: isPayment ? Colors.green : Colors.red),
                  title: Text("${isPayment ? "Paid" : "Purchase"} ₹${t['amount'].abs()}"),
                  subtitle: Text(t['note']),
                  trailing: Text(
                    t['date'].toString().split('T').first,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Text("Total Due: ₹${khata['totalDue'].toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.attach_money),
            label: const Text("Add Payment"),
            onPressed: () => _showPaymentDialog(context, khata['phone'],controller),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

void _showPaymentDialog(BuildContext context, String phone,AddKhataController controller) {
  final amountController = TextEditingController();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Add Payment"),
      content: TextField(
        controller: amountController,
        decoration: const InputDecoration(labelText: "Amount"),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () async {
            await controller.addPayment(phone, double.tryParse(amountController.text) ?? 0);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}
