import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/Customer.dart';
import '../../../widget/CustomerSearchDelegate.dart';
import '../../salepos/controller/salepos_controller.dart';
import '../controller/khata_controller.dart';

class KhataDashboard extends GetView<KhataController> {
  const KhataDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Khata Dashboard / खाता डैशबोर्ड")),
      body: SafeArea(
        child: Column(
          children: [
            // Customer Search
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  Customer? selectedCustomer = await showSearch<Customer?>(
                    context: context,
                    delegate: CustomerSearchDelegate(controller.customers),
                  );
                  if (selectedCustomer != null) {
                    //Get.to(() => CustomerLedgerScreen(customer: selectedCustomer));
                  }
                },
                icon: Icon(Icons.search),
                label: Text("Search Customer / ग्राहक खोजें"),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}