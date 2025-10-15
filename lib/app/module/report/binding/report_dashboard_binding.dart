import 'package:get/get.dart';

import '../controller/report_controller_controller.dart';


class ReportDashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ReportControllerController>(()=>ReportControllerController());
  }
}