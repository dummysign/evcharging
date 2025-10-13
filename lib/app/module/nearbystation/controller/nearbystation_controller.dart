

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NearByStationController extends GetxController{

  Rx<Position?> userPosition = Rx<Position?>(null);
  final List<LatLng> stations = [
    LatLng(28.6571,77.1424),
    LatLng(28.65116,77.15860),
    LatLng(28.65348,77.15571),
    LatLng(28.62039,77.24945),
    // Add more static or dynamic station locations
  ];

  @override
  void onInit() {
    super.onInit();
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
  }

  /*void openGoogleMaps(double lat, double lon) async {
    Uri uri;
    if (Platform.isIOS) {
      // Use Apple Maps URL scheme
      uri = Uri.parse('http://maps.apple.com/?daddr=$lat,$lon&dirflg=d');
    } else {
      // Use Google Maps URL
      uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving',
      );
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open map.';
    }
  }*/

  void openGoogleMaps(double lat, double lon) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

}