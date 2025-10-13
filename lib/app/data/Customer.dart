import 'package:get/get.dart';

class Customer {
  String name;
  String hindiName;
  RxList<Map<String, dynamic>> ledger = <Map<String, dynamic>>[].obs;

  Customer({required this.name, required this.hindiName});
}
