import 'package:evcharging/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../../common/api/utils/utils.dart';
import '../../../data/CarDetails.dart';
import '../../../widget/InputField.dart';
import '../../../widget/SimleInputBox.dart';
import '../controller/vendor_controller.dart';

class VendorView extends GetView<VendorController> {
  const VendorView({Key? key}) : super(key: key);

  // Example controllers

  // Dummy charging types

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Register Charging Station'),
        centerTitle: true,
        backgroundColor: AppColors.app_color,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
        children: [
        // Station Name
        SimleInputBox(
        label: 'Station Name',
          hintText: 'Enter Station Name',
          controller: controller.nameController.value,
        ),
        // Station Name
        //   _buildTextField("Station Name", controller.nameController),
        SizedBox(height: Get.height * 0.01),

        // Owner Name
        SimleInputBox(
          label: 'Owner Name',
          hintText: 'Enter Owner Name',
          controller: controller.ownerController.value,
        ),
        //_buildTextField("Owner Name",  controller.ownerController),
        SizedBox(height: Get.height * 0.01),
        // Contact
        SimleInputBox(
          label: 'Contact Number',
          hintText: 'Enter Contact Number',
          controller: controller.contactController.value,
          isPhoneInput: true,
        ),
        SizedBox(height: Get.height * 0.01),

        // Address
        SimleInputBox(
          label: 'Address',
          hintText: 'Enter Address',
          controller: controller.addressController.value,
          icon: Icons.location_on,
        ),
        SizedBox(height: Get.height * 0.01),
        Row(
          children: [
            Expanded(
              child: Obx(
                    () => InputField(
                  label: 'Charging Plus',
                  hintText: "Select Plus",
                  controller: controller.BrandController.value,
                  isenable: true,
                  //   isLoading: tagScreenViewModel.isLoading && tagScreenViewModel.stateList.isEmpty,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    controller.branddetails.clear();
                    controller.brandid.value = "";
                    controller.modelController.value.text = "";
                    controller.chargingTypeController.value.text = "";
                    if (controller.branddetails.isEmpty) {
                      Utils.loadingDialog(); // optional loader
                      await controller.fatch('BRAND');
                      Utils.closeDialog();
                    }
                    if (controller.branddetails.isNotEmpty) {
                      controller.showSearchDialog<Cardetails>(
                        context: context,
                        title: 'Select Plus',
                        options: controller.branddetails,
                        controller: controller.BrandController,
                        displayText: (item) =>
                        '${item?.brand ?? ''}',
                        filterCriteria: (item) => item.brand ?? '',
                        onItemSelected: (selected) async {
                          print('Selected ID: ${selected.id}');
                          //    controller.BrandController.value = selected.brand ?? '';
                          controller.brandid.value = selected.id ?? '';
                          /* controller.audit_cost_id.value = selected.id ?? '';
                          Utils.loadingDialog();
                          await controller.fatchALocation(selected.id ?? '');
                          Utils.closeDialog();*/
                        },
                      );
                    } else {
                      //Utils.shortToast(Storage.baseclient == "HITACHICASH" ? 'No Location Id available' : 'No Atm Id available');
                    }
                  },
                  isMandatory: true,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: Obx(
                    () => InputField(
                  label: 'Current type',
                  hintText: 'Enter type',
                  controller: controller.modelController.value,
                  isenable: true,
                  isreadonly: true,
                  //   isLoading: tagScreenViewModel.isLoading && tagScreenViewModel.stateList.isEmpty,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    controller.cardetails.clear();
                    if (controller.cardetails.isEmpty) {
                      Utils.loadingDialog(); // optional loader
                      await controller.fatch('MODEL');
                      Utils.closeDialog();
                    }
                    if (controller.cardetails.isNotEmpty) {
                      controller.showSearchDialog<Cardetails>(
                        context: context,
                        title: "Enter Capacity",
                        options: controller.cardetails,
                        controller: controller.modelController,
                        displayText: (item) => item.model ?? '',
                        filterCriteria: (item) => item.model ?? '',
                        onItemSelected: (selected) async {
                          controller.chargingTypeController.value.text =
                              selected.ChargingType ?? '';
                          controller.modelid.value = selected.id ??'';
                          controller.chargingtype.value = selected.ChargingType ??'';

                        },
                      );
                    } else {
                      // Utils.shortToast("No Location available");
                    }
                  },
                  isMandatory: true,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.02),
        Row(
          children: [
            Expanded(
              child: Obx(
                    () => InputField(
                  label: 'Capacity in Kwh',
                  hintText: 'Enter Capacity',
                  controller: controller.chargingTypeController.value,
                  isenable: true,
                  //   isLoading: tagScreenViewModel.isLoading && tagScreenViewModel.stateList.isEmpty,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  isMandatory: true,
                ),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            // For Sublocation //
            Expanded(
              child: Obx(
                    () => InputField(
                  label: 'No. of Charging Points',
                  hintText: 'Select No. of Charging Points',
                  controller: controller.pointsController.value,
                  isenable: true,
                  //   isLoading: tagScreenViewModel.isLoading && tagScreenViewModel.stateList.isEmpty,
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    controller.points.clear();
                    if (controller.points.isEmpty) {
                      Utils.loadingDialog(); // optional loader
                      await controller.fatch('Points');
                      Utils.closeDialog();
                    }
                    if (controller.points.isNotEmpty) {
                      controller.showSearchDialog<Cardetails>(
                        context: context,
                        title: "Select Points",
                        options: controller.points,
                        controller: controller.pointsController,
                        displayText: (item) =>
                        item.chargingpoints ?? '',
                        filterCriteria: (item) =>
                        item.chargingpoints ?? '',
                        onItemSelected: (selected) async {
                          controller.pointsController.value.text =
                              selected.chargingpoints ?? '';
                          controller.pointid.value =  selected.id ?? '';
                        },
                      );
                    } else {
                      // Utils.shortToast("No Location available");
                    }
                  },
                  isMandatory: true,
                ),
              ),
            ),
          ],
        ),
        // _buildTextField("Address",  controller.addressController.value, icon: Icons.location_on),
        // _buildTextField("Number of Charging Points",  controller.pointsController, keyboard: TextInputType.number),
        SizedBox(height: Get.height * 0.02),
        //   const SizedBox(height: 15),

        // Charging Types
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Extra Facilities ",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Obx(
              () => Wrap(
            spacing: 10,
            children: controller.allFacilities
                .map(
                  (type) => FilterChip(
                label: Text(type),
                selected: controller.selectedChargingTypes.contains(
                  type,
                ),
                onSelected: (bool selected) {
                  if (selected) {
                    controller.selectedChargingTypes.add(type);
                  } else {
                    controller.selectedChargingTypes.remove(type);
                  }
                },
              ),
            )
                .toList(),
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        // Open/Close Times
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () => Text(
                "Open Time: ${controller.openTime.value.format(context)}",
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.selectTime(context, true),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppColors.app_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: const Text(
                "Select",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
                  () => Text(
                "Close Time: ${controller.closeTime.value.format(context)}",
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.selectTime(context, false),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: AppColors.app_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: const Text(
                "Select",
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),

        SizedBox(height: Get.height * 0.02),

        // Upload Photo Placeholder
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await controller.pickImageFromCamera();
                },
                child: Obx(() {
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge, // Ensures image is clipped to borderRadius
                    child: controller.capturedImage.value != null
                        ? Image.file(
                      controller.capturedImage.value!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : const Center(
                      child: Text("Upload Station Photos"),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02),
            Expanded(
              child: GestureDetector(
                onTap: (){
                  controller.getAssetByQRCode();
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Obx(()=> Center(child: Text(
                      (controller.scannedCode?.value.isEmpty ?? true)
                          ? "Scan QR Code"
                          : controller.scannedCode.value!,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: Get.height * 0.03),

        // Submit
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (){
              FocusManager.instance.primaryFocus?.unfocus();
              if (controller != null) {
                print('Selected Charging Types: ${controller.selectedChargingTypes}');
                controller.uploadData();
              } else {
                print("❌ Controller is null");
              }
           //  controller.uploadData();
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
              "Submit",
              style: TextStyle(fontSize: 18, color: AppColors.white),
            ),
          ),
        ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
