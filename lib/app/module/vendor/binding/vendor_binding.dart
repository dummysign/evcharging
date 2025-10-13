

import 'package:get/get.dart';

import '../controller/vendor_controller.dart';

class VendorBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<VendorController>(()=>VendorController());
  }

}