
import 'package:get/get.dart';

import '../controller/addkhata_controller.dart';

class AddKhataBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AddKhataController>(()=>AddKhataController());
  }

}