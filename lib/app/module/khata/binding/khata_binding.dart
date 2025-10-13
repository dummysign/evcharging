import 'package:get/get.dart';

import '../controller/khata_controller.dart';


class KhataBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<KhataController>(()=>KhataController());
  }
}