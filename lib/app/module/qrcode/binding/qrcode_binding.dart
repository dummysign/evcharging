
import 'package:get/get.dart';

import '../controller/qrcode_controller.dart';

class QrCodebinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<QrCodeController>(()=>QrCodeController());
  }

}