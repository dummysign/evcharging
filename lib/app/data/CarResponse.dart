

import 'CarDetails.dart';

class CarResponse {
  String? responsecode;
  dynamic responsemessage;
  List<Cardetails>? carlist;

  CarResponse({
    this.responsecode,
    this.responsemessage,
    this.carlist,
  });

  CarResponse.fromJson(Map<String, dynamic> json) {
    responsecode = json['responsecode'];
    responsemessage = json['responsemessage'];
    if (json['carlist'] != null) {
      carlist = <Cardetails>[];
      json['carlist'].forEach((v) {
        carlist!.add(Cardetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['responsecode'] = responsecode;
    data['responsemessage'] = responsemessage;
    if (carlist != null) {
      data['carlist'] = carlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}