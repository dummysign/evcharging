

import 'package:get/get.dart';

import '../controller/stationlist_controller.dart';

class StationListBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<StationListController>(()=>StationListController());
  }

}