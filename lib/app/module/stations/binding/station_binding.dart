

import 'package:get/get.dart';

import '../controller/station_controller.dart';

class StationBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<StationController>(()=>StationController());
  }

}