

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/nearbystation_controller.dart';

class NearbystationView extends GetView<NearByStationController>{
  const NearbystationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: AppBar(title: const Text("Nearby Charging Stations")),
      body: Obx(() {
        final position = controller.userPosition.value;
        if (position == null) {
          return const Center(child: CircularProgressIndicator());
        }

        LatLng userLocation = LatLng(position.latitude, position.longitude);

        Set<Marker> markers = {
          Marker(
            markerId: const MarkerId('user'),
            position: userLocation,
            infoWindow: const InfoWindow(title: 'You Are Here'),
            icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
          ...controller.stations.map(
                (station) => Marker(
              markerId: MarkerId(station.toString()),
              position: station,
              infoWindow: InfoWindow(
                title: 'Charging Station',
                snippet: 'Tap to navigate',
                onTap: () => controller.openGoogleMaps(
                    station.latitude, station.longitude),
              ),
            ),
          ),
        };

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: userLocation,
            zoom: 14,
          ),
          markers: markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      }),
    );
  }

}