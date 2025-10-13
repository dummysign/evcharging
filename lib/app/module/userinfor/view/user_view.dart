

import 'package:evcharging/appcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../widget/SimleInputBox.dart';
import '../controller/user_controller.dart';

class UserView extends GetView<UserController>{
  const UserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          title: const Text('Car Info'),
          centerTitle: true,
          backgroundColor: AppColors.app_color
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                // Station Name
                Visibility(
                  visible: false,
                    child: SimleInputBox(label : 'Full Name',hintText: 'Enter Full Name',controller: controller.nameController.value)),
                // Station Name
                //   _buildTextField("Station Name", controller.nameController),
                Visibility(visible: false,child: SizedBox(height: Get.height * 0.01)),

                // Owner Name
            Visibility(visible: false,child: SimleInputBox(label : 'Phone Number',hintText: 'Enter Phone Number',controller: controller.phoneController.value)),
                //_buildTextField("Owner Name",  controller.ownerController),
            Visibility(visible: false,child: SizedBox(height: Get.height * 0.01)),
                // Contact
            Visibility(visible: false,child: SimleInputBox(label : 'Email Address (Optional)',hintText: 'Enter Email Address',controller: controller.emailController.value)),
               // SizedBox(height: Get.height * 0.01),
              //  const Divider(),

              //  Text("Vehicle Information", style: Theme.of(context).textTheme.bodyMedium),
                // Address

                SimleInputBox(label : 'Vehicle Make',hintText: 'Enter Vehicle Make',controller: controller.pointsController.value),

                // _buildTextField("Address",  controller.addressController.value, icon: Icons.location_on),
                SizedBox(height: Get.height * 0.01),
                // Charging Points
                SimleInputBox(label : 'Vehicle Model',hintText: 'Enter Vehicle Model',controller: controller.modelController.value),
                SizedBox(height: Get.height * 0.02),
                SimleInputBox(label : 'Registration Number (Optional)',hintText: 'Enter Registration Number',controller: controller.regNumberController.value),
                SizedBox(height: Get.height * 0.02),
                SimleInputBox(label : 'Battery Capacity (kWh)',hintText: 'Enter Battery Capacity (kWh)',controller: controller.batteryCapacityController.value),
                // _buildTextField("Number of Charging Points",  controller.pointsController, keyboard: TextInputType.number),
                SizedBox(height: Get.height * 0.02),
                //   const SizedBox(height: 15),

                // Charging Types
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Charging Port Type", style: Theme.of(context).textTheme.bodyMedium),
                ),
                Obx(() => DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  value: controller.selectedPortType.value.isNotEmpty ? controller.selectedPortType.value : null,
                  hint: const Text("Select Port Type"),
                  items: controller.portTypes
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.selectedPortType.value = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please select a port type';
                    return null;
                  },
                )),

                SizedBox(height: Get.height * 0.03),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (controller.formKey.currentState!.validate()) {
                        controller.uploadAssetData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.app_color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 4,
                    ),
                    child: const Text("Submit", style: TextStyle(fontSize: 18,color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}