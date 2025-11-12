import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../route/app_pages.dart';
import '../../../widget/CustomerLedgerScreen.dart';
import '../controller/khata_controller.dart';
import '../../../data/Customer.dart';
import '../../../widget/CustomerSearchDelegate.dart';

class KhataDashboard extends GetView<KhataController> {
  const KhataDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Khata Dashboard / खाता डैशबोर्ड")),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Customer Search
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  Customer? selectedCustomer = await showSearch<Customer?>(
                    context: context,
                    delegate: CustomerSearchDelegate(controller.customers),
                  );
                  if (selectedCustomer != null) {
                    // You can navigate to customer details screen here
                    // Get.to(() => CustomerLedgerScreen(customer: selectedCustomer));
                  }
                },
                icon: const Icon(Icons.search),
                label: const Text("Search Customer / ग्राहक खोजें"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

            // 🧾 List of Customers
            Expanded(
              child: Obx(() {
                if (controller.customers.isEmpty) {
                  return const Center(
                    child: Text("No customers found / कोई ग्राहक नहीं मिला"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.customers.length,
                  itemBuilder: (context, index) {
                    final customer = controller.customers[index];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            customer.name.isNotEmpty
                                ? customer.name[0].toUpperCase()
                                : "?",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(customer.name),
                        subtitle: Text(
                          customer.phone!.isNotEmpty
                              ? "📞 ${customer.phone}"
                              : "No phone number",
                        ),
                        trailing: Text(
                          "₹ ${customer.totalDue!.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: customer.totalDue! > 0
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () {
                          // You can open details or ledger here
                          Get.toNamed(Routes.CUSTLEDGER, arguments: customer);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
