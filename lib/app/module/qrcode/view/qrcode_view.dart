
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../appcolor.dart';
import '../../../widget/SimleInputBox.dart';
import '../controller/qrcode_controller.dart';

class QrCodeView extends GetView<QrCodeController>{
  const QrCodeView({Key? key}) : super(key: key);


/*  final String stationName;
  final String stationId;*/

 /* const QrCodeView({
    Key? key,
    required this.stationName,
    required this.stationId,
  }) : super(key: key);*/

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Box
            SimleInputBox(
              label: 'Station Name',
              hintText: 'Enter Station Name',
              controller: controller.nameController.value,
            ),

            const SizedBox(height: 16),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  controller.generateQRCode();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.app_color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "GENERATE QR Code",
                  style: TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // QR Code Display
            Obx(() {
              final qrData = controller.generatedName.value;
              if (qrData.isEmpty) return const SizedBox(); // No QR shown initially

              return Column(
                children: [
                  Screenshot(
                    controller: controller.screenshotController,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              qrData,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            QrImageView(
                              data: qrData,
                              size: 200,
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              embeddedImage:
                              const AssetImage("assets/evlogo1.png"),
                              embeddedImageStyle: const QrEmbeddedImageStyle(
                                size: Size(40, 40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Download Button
                  ElevatedButton.icon(
                    onPressed: () => controller.downloadQRCodeAsDoc(qrData),
                    icon: const Icon(Icons.download),
                    label: const Text("Download QR Code"),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}