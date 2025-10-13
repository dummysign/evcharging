import 'package:get/get.dart';
import '../controller/addproduct_controller.dart';

class AddproductBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AddProductController>(()=>AddProductController());
  }
}