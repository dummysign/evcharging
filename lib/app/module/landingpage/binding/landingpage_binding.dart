

import 'package:get/get.dart';

import '../controller/landingpage_controller.dart';

class LandingPageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LandingPageController>(()=>LandingPageController());
  }

}