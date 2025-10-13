
import 'package:get/get.dart';

import '../controller/nearbystation_controller.dart';


class NearbystationBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<NearByStationController>(()=>NearByStationController());
  }
}