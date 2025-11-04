

import 'package:get/get.dart';

import '../controller/sptext_controller.dart';

class SptextBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SpeechController>(()=>SpeechController());
  }

}