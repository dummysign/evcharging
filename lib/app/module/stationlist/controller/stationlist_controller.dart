

import 'package:evcharging/common/api/utils/extension.dart';
import 'package:get/get.dart';

import '../../../../common/api/data/ApiHelper.dart';
import '../../../../common/api/utils/utils.dart';
import '../../../data/stationdetails.dart';

class StationListController extends GetxController{

  final ApiHelper _apiHelper = Get.find();
  final _body = <String, dynamic>{};
  RxList<DetailsResponse> stationlist = <DetailsResponse>[].obs;


  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
    Loaddata();
  }

  void Loaddata() {
    Utils.loadingDialog();
    _body["database"] ="aananda_macotest";
    _body["brandid"] ="";
    _body["modelid"] ="";

    printInfo(info: 'body: $_body');

    _apiHelper.GetChargingStation(_body).futureValue((v) {
      printInfo(info: v.responsecode!);
      Utils.closeDialog();
      if(v.responsecode =="200"){
        stationlist.value = v.stationlist ?? [];

      }else {
        Get.snackbar("Error",v.responsemessage ?? '');
      }

    },
    );
  }


  /*@override
  void onReady() {
    super.onReady();
    // 👈 This ensures API runs automatically when the dashboard screen loads
  }*/
}