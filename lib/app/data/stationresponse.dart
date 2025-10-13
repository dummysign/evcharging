

import 'package:evcharging/app/data/stationdetails.dart';

class StationResponse {
  String? responsecode;
  dynamic responsemessage;
  List<DetailsResponse>? stationlist;



  StationResponse({
    this.responsecode,
    this.responsemessage,
    this.stationlist,
  });

  StationResponse.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemessage = json['responsemessage'];
    if (json['stationlist'] != null) {
      stationlist = <DetailsResponse>[];
      json['stationlist'].forEach((v) {
        stationlist!.add(DetailsResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemessage'] = responsemessage;
    if (stationlist != null) {
      data['stationlist'] = stationlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}