import 'package:get/get.dart';

import '../controller/report_controller_controller.dart';
import '../controller/sales_report_controller.dart';


class SalesReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SalesReportController>(()=>SalesReportController());
  }
}