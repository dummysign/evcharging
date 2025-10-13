

import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class QrCodeController extends GetxController{

  final ScreenshotController screenshotController = ScreenshotController();
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final RxString generatedName = ''.obs;
 // final Rx<TextEditingController> screenshotController = TextEditingController().obs;
  /*Future<void> downloadQRCodeAsDoc(String stationName) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar("Permission Denied", "Storage access is required to save the QR code.");
      return;
    }

    Uint8List? image = await screenshotController.capture();
    if (image == null) {
      Get.snackbar("Error", "Failed to capture QR code.");
      return;
    }

    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/${stationName}_QR.png';
    final file = File(path);
    await file.writeAsBytes(image);

    Get.snackbar("Success", "QR Code saved at: $path");
  }*/

  Future<void> downloadQRCodeAsDoc(String stationName) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
      } else {
        status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }
    } else {
      // iOS
      status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
    } // Use .photos for Android 13+
    if (!status.isGranted) {
      Get.snackbar("Permission Denied", "Storage access is required to save the QR code.");
      return;
    }

    final Uint8List? image = await screenshotController.capture();
    if (image == null) {
      Get.snackbar("Error", "Failed to capture QR code.");
      return;
    }

    final result = await ImageGallerySaverPlus.saveImage(
      image,
      quality: 100,
      name: "${stationName}_QR",
    );

    if (result['isSuccess'] == true) {
      Get.snackbar("Success", "QR Code saved to Gallery.");
    } else {
      Get.snackbar("Error", "Failed to save QR code.");
    }
  }


  /*Future<void> downloadQRCodeAsDoc(String stationName) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      Get.snackbar("Permission Denied", "Storage access is required to save the QR code.");
      return;
    }

    // Capture the QR code
    final Uint8List? image = await screenshotController.capture();
    if (image == null) {
      Get.snackbar("Error", "Failed to capture QR code.");
      return;
    }

    // Save image temporarily
    final tempDir = await getTemporaryDirectory();
    final imagePath = "${tempDir.path}/$stationName.png";
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(image);
    final imageBytes = await imageFile.readAsBytes();

    // Load the DOCX template
    final templateData = await rootBundle.load('assets/template.docx');
    final docx = await DocxTemplate.fromBytes(templateData.buffer.asUint8List());

    // Create the content with image inside a list block
    final content = Content();
    content.add(ListContent("qr", [
      Content()
        ..add(ImageContent('qrImage', imageBytes)), // ✅ pass bytes, not File
    ]));

    // Generate the document
    final docxBytes = await docx.generate(content);
    if (docxBytes == null) {
      Get.snackbar("Error", "Failed to generate document.");
      return;
    }

    final filePath = "${tempDir.path}/${stationName}_QR.docx";
    final file = File(filePath)..writeAsBytesSync(docxBytes);

    Get.snackbar("Success", "Saved as DOCX: $filePath");
  }*/

  void generateQRCode() {
    final name = nameController.value.text.trim();
    if (name.isNotEmpty) {
      generatedName.value = name;
    } else {
      Get.snackbar("Input Required", "Please enter a station name.");
    }
  }
}