 import 'package:get/get.dart';

import '../../../app/data/CarResponse.dart';
import '../../../app/data/SaveResponse.dart';
import '../../../app/data/stationresponse.dart';

mixin ApiHelper{
   Future<Response<CarResponse>> CarModel(Map<String,dynamic> data);
   Future<Response<CarResponse>> ChargingPoints(Map<String,dynamic> data);
   Future<Response<SaveResponse>> UploadStationdata(FormData formData);
   Future<Response<StationResponse>> GetChargingStation(Map<String,dynamic> data);
 }