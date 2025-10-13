

import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController{
  late String assetId;
  RxBool isScanning = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onDetect(String code , String type) {
    if (isScanning.value) {
      isScanning.value = false;
    //  printInfo("HHHHHRETURN FROM SCANNER");
      Get.back(result: {
        'scannedValue': code,
        'scantype': type,

      });
    }
  }
}