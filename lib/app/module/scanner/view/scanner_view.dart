
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../appcolor.dart';
import '../controller/scanner_controller.dart';

class ScannerView extends GetView<ScannerController>{

  const ScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR/Barcode'),
        centerTitle: true,
        backgroundColor: AppColors.app_color,
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          formats: [BarcodeFormat.all], // scans all types: QR, Code128, etc.
        ),
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final value = barcode.rawValue ?? '';
          final format = barcode.format;
          String scanType = '';
          if (format == BarcodeFormat.qrCode) {
            scanType = 'QR Code';
          } else {
            scanType = 'Barcode';
          }
          controller.onDetect(value,scanType);
        },
      ),
    );
  }
}