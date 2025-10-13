

import 'package:evcharging/app/module/qrcode/controller/qrcode_controller.dart';
import 'package:get/get.dart';

import '../../landingpage/controller/landingpage_controller.dart';
import '../../nearbystation/controller/nearbystation_controller.dart';
import '../../stationlist/controller/stationlist_controller.dart';
import '../../stations/controller/station_controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(()=>HomeController());
    Get.lazyPut<LandingPageController>(() => LandingPageController(),);
    Get.lazyPut<StationController>(() => StationController(),);
    Get.lazyPut<NearByStationController>(() => NearByStationController(),);
    Get.lazyPut<QrCodeController>(() => QrCodeController(),);
    Get.lazyPut<StationListController>(() => StationListController(),);
  }
}