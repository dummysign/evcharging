
import 'dart:convert';

import 'package:evcharging/app/data/CarResponse.dart';
import 'package:evcharging/app/data/SaveResponse.dart';
import 'package:get/get.dart';

import '../../../app/data/CarDetails.dart';
import '../../../app/data/stationresponse.dart';
import '../../constant/Constants.dart';
import '../storage/storage.dart';
import 'ApiHelper.dart';
import 'all_api_url.dart';

class ApiHelperImpl extends GetConnect with ApiHelper{
  @override
  void onInit() {
    httpClient.baseUrl = Constants.BASE_URL;
    httpClient.timeout = Constants.timeout;
    //  addRequestModifier();
    httpClient.addResponseModifier((request, response) {
      printInfo(
        info: 'Status Code: ${response.statusCode}\n'
            'Data: ${response.bodyString?.toString() ?? ''}',
      );
      return response;
    });
  }

  @override
  Future<Response<CarResponse>> CarModel(Map<String, dynamic> data) {
    return post(
      "http://157.20.51.113/apitesteams/eamsapi.svc/"+Cardetailsapi,                  // URL
      data,                   // BODY (positional argument)
      decoder: (v) => CarResponse.fromJson(v),
    );
  }

  @override
  Future<Response<CarResponse>> ChargingPoints(Map<String, dynamic> data) {
    return post(
      "http://157.20.51.113/apitesteams/eamsapi.svc/"+GetChargingPoints,                  // URL
      data,                   // BODY (positional argument)
      decoder: (v) => CarResponse.fromJson(v),
    );
  }

  @override
  Future<Response<SaveResponse>> UploadStationdata(FormData formData) {
    return post(
      "http://157.20.51.113/apitesteams/eamsapi.svc/"+UploadStation, // Your endpoint
      formData,
      contentType: 'multipart/form-data',
      decoder:(v) {
        if (v is Map<String, dynamic>) {
          return SaveResponse.fromJson(v);
        } else if (v is String) {
          return SaveResponse.fromJson(jsonDecode(v));
        }
        print('Decoding error: $v');
        throw Exception('Unexpected response type: $v');
      },
    );
  }

  @override
  Future<Response<StationResponse>> GetChargingStation(Map<String, dynamic> data) {
    return post(
      "http://157.20.51.113/apitesteams/eamsapi.svc/"+ChargingStation,                  // URL
      data,                   // BODY (positional argument)
      decoder: (v) => StationResponse.fromJson(v),
    );
  }


}