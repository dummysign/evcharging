import 'package:get/get.dart';

import '../controller/customerledger_controller.dart';

class CustomerledgerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<CustomerLedgerController>(()=>CustomerLedgerController());
  }
}