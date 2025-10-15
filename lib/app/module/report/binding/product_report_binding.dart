import 'package:get/get.dart';

import '../controller/product_report_controller.dart';


class ProductReportBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ProductReportController>(()=>ProductReportController());
  }
}