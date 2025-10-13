import 'package:get/get.dart';

import '../controller/salepos_controller.dart';

class SaleposBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(()=>ShopController());
  }
}