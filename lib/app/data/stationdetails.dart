

class DetailsResponse{
  String? chargingpoints;
  dynamic chargingtype;
  dynamic closetime;
  String? extrafacilities1;
  dynamic extrafacilities2;
  dynamic extrafacilities3;
  dynamic extrafacilities4;
  dynamic latitude;
  dynamic longitude;
  dynamic mobileno;
  dynamic opentime;
  dynamic stationimage;
  dynamic stationname;

  DetailsResponse(
      {this.chargingpoints,
        this.chargingtype,
        this.closetime,
        this.extrafacilities1,
        this.extrafacilities2,
        this.extrafacilities3,
        this.extrafacilities4,
        this.latitude,
        this.longitude,
        this.mobileno,
        this.opentime,
        this.stationimage,
        this.stationname,
      });

  DetailsResponse.fromJson(Map<String, dynamic> json) {
    chargingpoints = json['chargingpoints'];
    chargingtype = json['chargingtype'];
    closetime = json['closetime'];
    extrafacilities1 = json['extrafacilities1'];
    extrafacilities2 = json['extrafacilities2'];
    extrafacilities3 = json['extrafacilities3'];
    extrafacilities4 = json['extrafacilities4'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mobileno = json['mobileno'];
    opentime = json['opentime'];
    stationimage = json['stationimage'];
    stationname = json['stationname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chargingpoints'] = this.chargingpoints;
    data['chargingtype'] = this.chargingtype;
    data['closetime'] = this.closetime;
    data['extrafacilities1'] = this.extrafacilities1;
    data['extrafacilities2'] = this.extrafacilities2;
    data['extrafacilities3'] = this.extrafacilities3;
    data['extrafacilities4'] = this.extrafacilities4;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['mobileno'] = this.mobileno;
    data['opentime'] = this.opentime;
    data['stationimage'] = this.stationimage;
    data['stationname'] = this.stationname;
    return data;
  }

}