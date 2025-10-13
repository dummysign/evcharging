

import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/reviewmodel.dart';
import '../../../data/stationmodel.dart';

class StationController extends GetxController{


  Rx<Position?> userPosition = Rx<Position?>(null);
  var reviews = <ReviewModel>[].obs;

  // Mock reviews map
  final Map<String, List<ReviewModel>> _mockReviews = {
    "1": [
      ReviewModel(userName: "Alice", rating: 5, comment: "Great station!"),
      ReviewModel(userName: "Bob", rating: 4, comment: "Easy to access."),
      ReviewModel(userName: "Bob", rating: 4, comment: "Easy to access."),
      ReviewModel(userName: "Bob", rating: 4, comment: "Easy to access."),
      ReviewModel(userName: "Bob", rating: 4, comment: "Easy to access."),
      ReviewModel(userName: "Bob", rating: 4, comment: "Easy to access."),
    ],
    "2": [
      ReviewModel(userName: "Charlie", rating: 3, comment: "Needs more plugs."),
    ],
  };



  final stations = <StationModel>[
    StationModel(
      id: "1",
      latitude: 28.6571,
      longitude: 77.1424,
      name: "Station A",
      address: "Address 1, Delhi",
      contact: "+91 9876543210",
      imageUrl: "http://157.20.51.113/apitesteams/Stationimage/2025-08-08 13-13-00_1.jpg",
      plugType: "CCS2",
      currentType: "DC",
      kwh: 50.0,
    ),
    StationModel(
      id: "2",
      latitude: 28.65116,
      longitude: 77.15860,
      name: "Station B",
      address: "Address 2, Delhi",
      contact: "+91 9123456780",
      imageUrl: "http://157.20.51.113/apitesteams/Stationimage/2025-08-08 13-13-00_1.jpg",
      plugType: "Type2",
      currentType: "AC",
      kwh: 22.0,
    ),
  ].obs;

 /* final List<LatLng> stations = [
    LatLng(28.6571,77.1424),
    LatLng(28.65116,77.15860),
    LatLng(28.65348,77.15571),
    LatLng(28.62039,77.24945),
    LatLng(28.547217,77.244324),
    LatLng(28.608947,77.362725),
    // Add more static or dynamic station locations
  ];*/

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    //loaddata();
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


  void loadReviews(String stationId) {
    reviews.value = _mockReviews[stationId] ?? [];
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

  Future<void> updateUserLocation() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    userPosition.value = pos;
  }

  /// Calculate distance (km) and ETA (minutes) to a station
  Map<String, double?> getDistanceAndEta({
    required double stationLat,
    required double stationLon,
  }) {
    if (userPosition.value == null) return {"distanceKm": null, "etaMinutes": null};

    final double distanceMeters = Geolocator.distanceBetween(
      userPosition.value!.latitude,
      userPosition.value!.longitude,
      stationLat,
      stationLon,
    );

    double distanceKm = distanceMeters / 1000;
    double etaMinutes = (distanceKm / 40) * 60; // avg speed 40 km/h

    return {
      "distanceKm": distanceKm,
      "etaMinutes": etaMinutes,
    };
  }



}