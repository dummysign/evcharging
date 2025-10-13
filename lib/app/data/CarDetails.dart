
class Cardetails{
  String? ChargingType;
  dynamic brand;
  dynamic chargingpoints;
  String? id;
  dynamic model;

  Cardetails(
      {this.ChargingType, this.brand, this.chargingpoints, this.id,this.model});

  Cardetails.fromJson(Map<String, dynamic> json) {
    ChargingType = json['ChargingType'];
    brand = json['brand'];
    chargingpoints = json['chargingpoints'];
    id = json['id'];
    model = json['model'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ChargingType'] = this.ChargingType;
    data['brand'] = this.brand;
    data['chargingpoints'] = this.chargingpoints;
    data['id'] = this.id;
    data['model'] = this.model;
    return data;
  }
}