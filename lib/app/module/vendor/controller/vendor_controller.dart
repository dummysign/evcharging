
import 'dart:io';

import 'package:evcharging/app/data/CarDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/api/data/ApiHelper.dart';
import '../../../../common/api/utils/utils.dart';
import '../../../route/app_pages.dart';
import '../../../widget/SearchableMultiSelectionDialog.dart';
import '../../../widget/SearchableSelectionDialog.dart';

class VendorController extends GetxController{
  final List<String> chargingTypes = ['AC', 'DC', 'Type 2', 'CCS', 'Type 2', 'CCS'];
  final RxList<String> selectedChargingTypes = <String>[].obs;
  RxList<String> selectedFacilities = <String>[].obs;


  List<String> allFacilities = [
    "Restaurant",
    "Washroom",
    "Mall",
    "EV Charger",
    "Parking",
    "Coffee Shop",
  ];
  final Rx<TextEditingController> nameController = TextEditingController().obs;
  final Rx<TextEditingController> ownerController = TextEditingController().obs;
  final Rx<TextEditingController> contactController = TextEditingController().obs;
  final Rx<TextEditingController> addressController = TextEditingController().obs;
  final Rx<TextEditingController> pointsController = TextEditingController().obs;
  final Rx<TextEditingController> modelController = TextEditingController().obs;
  final Rx<TextEditingController> BrandController = TextEditingController().obs;
  final Rx<TextEditingController> chargingTypeController = TextEditingController().obs;
  Rx<TimeOfDay> openTime = TimeOfDay.now().obs;
  RxBool isnextclick = false.obs;
  RxString brandid = ''.obs;
  RxString modelid = ''.obs;
  RxString chargingtype = ''.obs;
  FormData form  = FormData({});
  RxString pointid = ''.obs;
  final ImagePicker _picker = ImagePicker();
  Rx<File?> capturedImage = Rx<File?>(null);
  Rx<TimeOfDay> closeTime = TimeOfDay(hour: 20, minute: 0).obs;
  RxList<Cardetails> cardetails = <Cardetails>[].obs;
  RxList<Cardetails> branddetails = <Cardetails>[].obs;
  RxList<Cardetails> points = <Cardetails>[].obs;
  //TimeOfDay closeTime = TimeOfDay(hour: 20, minute: 0);
  final formKey = GlobalKey<FormState>();

  final ApiHelper _apiHelper = Get.find();
  final _body2 = <String, dynamic>{};
  final _body1 = <String, dynamic>{};
  Rx<Position?> userPosition = Rx<Position?>(null);
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxString Livelocation = ''.obs;
  RxString  scannedCode = ''.obs;
  late String scantype;


  @override
  void onInit() {
    super.onInit();
    // onGetAssetDetails();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Error", "Location permission permanently denied");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    userPosition.value = position;
    if (userPosition.value != null) {
      latitude.value = userPosition.value!.latitude.toString();
      longitude.value = userPosition.value!.longitude.toString();
      //   Livelocation.value = userPosition.value.
    }
  }

  Future<void> selectTime(BuildContext context, bool isOpen) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isOpen ? openTime.value : closeTime.value,
    );
    if (picked != null) {
      if (isOpen) {
        openTime.value = picked;
      } else {
        closeTime.value = picked;
      }
    }
  }


  void getAssetByQRCode()  async {

    final result = await Get.toNamed(Routes.SCANNERVIEW);
    if (result != null) {
      scannedCode.value = result['scannedValue'];
      scantype = result['scantype'];
      print('Scanned: $scannedCode for asset ID: $scantype');
    }
  }



  Future<void>  fatch(String type) async {
    if (type == "BRAND") {
      _body2.clear();
      _body2["database"] = "aananda_macotest";
      _body2["brandid"] = brandid.value;


      try {
        final v = await _apiHelper.CarModel(_body2);
        Utils.closeDialog();
        if (v.body?.responsecode == "200") {
          branddetails.value = v.body?.carlist ?? [];
        //  Utils.shortToast(v.body?.responseMessage);
        } else {
         // Utils.shortToast(v.body?.responseMessage);
        }
      } catch (e) {
        print("Error fetching Address: $e");
        Utils.closeDialog();
      }
    }else if (type == "MODEL") {
      _body2.clear();
      _body2["database"] = "aananda_macotest";
      _body2["brandid"] = brandid.value;


      try {
        final v = await _apiHelper.CarModel(_body2);
        Utils.closeDialog();
        if (v.body?.responsecode == "200") {
          cardetails.value = v.body?.carlist ?? [];
          //  Utils.shortToast(v.body?.responseMessage);
        } else {
          // Utils.shortToast(v.body?.responseMessage);
        }
      } catch (e) {
        print("Error fetching Address: $e");
        Utils.closeDialog();
      }
    }
    else if (type == 'Points'){
      _body2.clear();
      _body2["database"] = "aananda_macotest";
      try {
        final v = await _apiHelper.ChargingPoints(_body2);
        Utils.closeDialog();
        if (v.body?.responsecode == "200") {
          points.value = v.body?.carlist ?? [];
        } else {
        }
      } catch (e) {
        print("Error fetching Address: $e");
        Utils.closeDialog();
      }
    }
  }

  void showSearchDialog<T>({
    required BuildContext context,
    required String title,
    required List<T> options,
    required Rx<TextEditingController> controller,
    required String Function(T) displayText,
    required String Function(T) filterCriteria,
    required void Function(T selectedItem) onItemSelected,
  }) async {
    final result = await SearchableSelectionDialog.show<T>(
      context,
      options: options,
      title: title,
      displayText: displayText,
      filterCriteria: filterCriteria,
    );

    if (result != null) {
      controller.value.text = displayText(result);
      onItemSelected(result); // callback with selected item
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      capturedImage.value = File(photo.path);
      if (capturedImage.value != null) {
        form.files.add(MapEntry(
          'stationimage',
          MultipartFile(capturedImage.value!, filename: 'img1.jpg'),
        ));
      }
      print("Image Path: ${photo.path}");
    }
  }

  void showMultiSearchDialog<T>({
    required BuildContext context,
    required String title,
    required List<T> options,
    required RxList<T> selectedItems, // <-- RxList instead of single controller
    required String Function(T) displayText,
    required String Function(T) filterCriteria,
  }) async {
    final result = await SearchableMultiSelectionDialog.show<T>(
      context,
      options: options,
      title: title,
      selectedItems: selectedItems,
      displayText: displayText,
      filterCriteria: filterCriteria,
    );

    if (result != null) {
      selectedItems.assignAll(result);
    }
  }
  Future<void> uploadData() async {
    print("Upload triggeredddff{}");
  //  Utils.loadingDialog();
    try {
      Utils.loadingDialog();
      await Future.delayed(Duration(milliseconds: 100));
      // Create form data
    //  form = await Future.microtask(() => _buildForm());
     // final fields = _buildFormFields().entries;
     form.fields.addAll(_buildFormFields().map((key, value) => MapEntry(key, value?.toString() ?? ''))
          .entries);
   //   form.fields = FormData(fields);
      final response = await _apiHelper.UploadStationdata(form);
      printInfo(info: response.body?.responseMessage);
      if (response.body?.responseCode == "200") {
        printInfo(info: response.body?.responseMessage);
        Utils.closeDialog();
        resetAssetFormOnQr();
        Utils.showCustomConfirmationDialog( title: "Confirmation",message :"Data has been saved successfully.",
            backgroundColor: Colors.green.shade700);
      //  imageFile1.value = null;
     //   imageFile2.value = null;
       // resetAssetForm();
      } else {
        Utils.closeDialog();
        resetAssetFormOnQr();
        Utils.showCustomConfirmationDialog( title: "Confirmation",message :response.body?.responseMessage ?? "Upload failed.",
            backgroundColor: Colors.red.shade700);
      }
    }catch(e) {
      Utils.closeDialog();
      resetAssetFormOnQr();
      Utils.showCustomConfirmationDialog( title: "Confirmation",message :"Upload error: $e",
          backgroundColor: Colors.red.shade700);
    }

  }

  FormData _buildForm() {
    final List<String> facilities = selectedChargingTypes;
   final form =  FormData({
      'database': 'aananda_macotest',
      'stationname': nameController.value.text ?? '',
      'ownername': ownerController.value.text ?? '',
      'monileno': contactController.value.text ?? '',
      'stataddress': addressController.value.text ?? '',
      'brandid': brandid.value ?? '',
      'modelid': modelid.value ?? '',
      'chargingtype': chargingTypeController.value.text ?? '',
      'chargingpoints': pointid.value ?? '',
      'extrafacilities1': facilities.length > 0 ? facilities[0] : '',
      'extrafacilities2': facilities.length > 1 ? facilities[1] : '',
      'extrafacilities3': facilities.length > 2 ? facilities[2] : '',
      'extrafacilities4': facilities.length > 3 ? facilities[3] : '',
      'opentime': _formatTime(openTime.value.toString()) ?? '',
      'closetime': _formatTime(closeTime.value.toString()) ?? '',
      'brcd': scannedCode.value ?? '',
      'lat': latitude.value ?? '',
      'lon': longitude.value ?? '',
    });
    /*if (capturedImage.value != null) {
      form.files.add(MapEntry(
        'stationimage',
        MultipartFile(capturedImage.value!, filename: 'img1.jpg'),
      ));
    }*/
    return form;
  }


  String _formatTime(String time) {
    if (time.contains('TimeOfDay(')) {
      return time.replaceAll('TimeOfDay(', '').replaceAll(')', '');
    }
    return time;
  }

  Map<String, dynamic> _buildFormFields() {
    final facilities = selectedChargingTypes;
    return {
      'database': 'aananda_macotest',
      'stationname': nameController.value.text,
      'ownername': ownerController.value.text,
      'monileno': contactController.value.text,
      'stataddress': addressController.value.text,
      'brandid': brandid.value,
      'modelid': modelid.value,
      'chargingtype': chargingTypeController.value.text,
      'chargingpoints': pointid.value,
      'extrafacilities1': facilities.length > 0 ? facilities[0] : '',
      'extrafacilities2': facilities.length > 1 ? facilities[1] : '',
      'extrafacilities3': facilities.length > 2 ? facilities[2] : '',
      'extrafacilities4': facilities.length > 3 ? facilities[3] : '',
      'opentime': _formatTime(openTime.value.toString()),
      'closetime': _formatTime(closeTime.value.toString()),
      'brcd': scannedCode.value,
      'lat': latitude.value,
      'lon': longitude.value,
    };
  }

  void resetAssetFormOnQr() {
    // Clear text controllers
    nameController.value.clear();
    ownerController.value.clear();
    contactController.value.clear();
    addressController.value.clear();
    chargingTypeController.value.clear();
    selectedChargingTypes.value.clear();

    // Reset IDs
    brandid.value = '';
    modelid.value = '';
    scannedCode.value = '';

    // Reset images
    capturedImage.value = null;
    form.fields.clear();
    form.files.clear();
  }

}