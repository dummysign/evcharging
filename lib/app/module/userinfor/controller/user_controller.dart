

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../route/app_pages.dart';

class UserController extends GetxController{
  final List<String> chargingTypes = ['AC', 'DC', 'Type 2', 'CCS'];
  final RxList<String> selectedChargingTypes = <String>[].obs;
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> ownerController = TextEditingController().obs;
  final Rx<TextEditingController> phoneController = TextEditingController().obs;
  final Rx<TextEditingController> contactController = TextEditingController().obs;
  final Rx<TextEditingController> emailController = TextEditingController().obs;
  final Rx<TextEditingController> addressController = TextEditingController().obs;
  final Rx<TextEditingController> pointsController = TextEditingController().obs;
  final Rx<TextEditingController> modelController = TextEditingController().obs;
  final Rx<TextEditingController> regNumberController = TextEditingController().obs;
  final Rx<TextEditingController> batteryCapacityController = TextEditingController().obs;
  final Rx<TextEditingController> makeController = TextEditingController().obs;
  Rx<TimeOfDay> openTime = TimeOfDay.now().obs;
  final RxString selectedPortType = ''.obs;

  final List<String> portTypes = ['Type 2', 'CCS', 'CHAdeMO', 'GB/T'];
  Rx<TimeOfDay> closeTime = TimeOfDay(hour: 20, minute: 0).obs;
  //TimeOfDay closeTime = TimeOfDay(hour: 20, minute: 0);
  final formKey = GlobalKey<FormState>();

  void uploadAssetData() {
    Get.toNamed(Routes.STATIONMARK);
  }

}