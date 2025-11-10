import 'package:get/get.dart';

class Customer {
  final String name;
  final String hindiName;
  final String? phone;
  final double? totalDue;

  Customer({
    required this.name,
    required this.hindiName,
    this.phone,
    this.totalDue,
  });
}
