
class StationModel{
  final String id;
  final double latitude;
  final double longitude;
  final String? name;
  final String? address;
  final String? contact;
  final String? imageUrl;
  final String? plugType;      // e.g. "CCS2", "Type2"
  final String? currentType;   // e.g. "AC", "DC"
  final double? kwh;           // e.g. 50.0

  StationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.name,
    this.address,
    this.contact,
    this.imageUrl,
    this.plugType,
    this.currentType,
    this.kwh,
  });
}