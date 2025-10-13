

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../appcolor.dart';
import '../../../data/stationmodel.dart';
import '../controller/station_controller.dart';

class StationView extends GetView<StationController>{
  const StationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Charging Stations")),
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
         /* ...controller.stations.map(
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
          ),*/
          ...controller.stations.map(
                (station) => Marker(
              markerId: MarkerId(station.id),
              position: LatLng(station.latitude, station.longitude),
              onTap: () => _showStationBottomSheet(context, station),
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


 /* void _showStationBottomSheet(BuildContext context, StationModel station) {
    showModalBottomSheet(
      context: context,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'images/evlogo1.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                *//*child: Image.network(
                  station.imageUrl ?? 'https://via.placeholder.com/150',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),*//*
              ),
               SizedBox(height: 12),
              Text(
                station.name ?? "Charging Station",
                style:
                 TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
               SizedBox(height: 4),
              Text(station.address ?? "No address available"),
               SizedBox(height: 8),
              Row(
                children: [
                   Icon(Icons.phone, size: 18),
                   SizedBox(width: 6),
                  Text(station.contact ?? "Not available"),
                ],
              ),
               SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.openGoogleMaps(
                        station.latitude, station.longitude);
                  },
                  icon:  Icon(Icons.navigation),
                  label:  Text("Navigate"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }*/

  void _showStationBottomSheet(BuildContext context, StationModel station) {
    controller.loadReviews(station.id);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Station image at top
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'images/evlogo1.png', // <-- static local image
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),

                // Tab bar
                const TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: "Info"),
                    Tab(text: "Reviews"),
                    Tab(text: "Photos"),
                  ],
                ),

                // Tab content
                SizedBox(
                  height: 350, // fixed height for content
                  child: TabBarView(
                    children: [
                      // 1) Info & Details tab
                      _buildInfoTab(station),

                      // 2) Reviews tab
                      _buildReviewsTab(),
                    //  Center(child: Text("Reviews coming soon...")),

                      // 3) Photos tab
                      Center(child: Text("Photos gallery coming soon...")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Info Tab Widget
  Widget _buildInfoTab(StationModel station) {
    final data = controller.getDistanceAndEta(
      stationLat: station.latitude,
      stationLon: station.longitude,
    );

    final distanceKm = data["distanceKm"];
    final etaMinutes = data["etaMinutes"];

    return Column(
      children: [
        // Station Info Card
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  station.name ?? "Charging Station",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_city, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        station.address ?? "No address available",
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Distance & ETA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoChip(
                      icon: Icons.location_on,
                      label: distanceKm != null
                          ? "${distanceKm.toStringAsFixed(2)} km"
                          : "Distance N/A",
                      color: Colors.redAccent,
                    ),
                    _infoChip(
                      icon: Icons.access_time,
                      label: etaMinutes != null
                          ? "${etaMinutes.toStringAsFixed(0)} min"
                          : "ETA N/A",
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Charging Details Section
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  "Charging Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _detailTile(
                      icon: Icons.ev_station,
                      title: "Plug Type",
                      value: station.plugType ?? "Unknown",
                    ),
                    _detailTile(
                      icon: Icons.power,
                      title: "Current",
                      value: station.currentType ?? "Unknown",
                    ),
                    _detailTile(
                      icon: Icons.bolt,
                      title: "Capacity",
                      value: station.kwh != null
                          ? "${station.kwh} kWh"
                          : "Unknown",
                    ),
                  ],
                ),

                SizedBox(height: 5),

                // Contact
                Row(
                  children: [
                    const Icon(Icons.phone, size: 18, color: Colors.green),
                    const SizedBox(width: 6),
                    Text(station.contact ?? "Not available"),
                  ],
                ),
              ],
            ),
          ),
        ),

      //  const Spacer(),

        // Navigate Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding:  EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppColors.app_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
            ),
            onPressed: () {
              controller.openGoogleMaps(
                station.latitude,
                station.longitude,
              );
            },
            icon: const Icon(Icons.navigation),
            label: const Text(
              "Navigate",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// Small chip-like UI for Distance & ETA
  Widget _infoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Charging detail tile
  Widget _detailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22, color: Colors.teal),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  Widget _buildReviewsTab() {
    return Obx(() {
      final reviews = controller.reviews;

      if (reviews.isEmpty) {
        return const Center(
          child: Text(
            "No reviews yet.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        itemCount: reviews.length,
        separatorBuilder: (_, __) => const SizedBox(height: 5),
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Circle avatar with first letter
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade300,
                        child: Text(
                          review.userName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      // Star rating
                      Row(
                        children: List.generate(5, (i) {
                          return Icon(
                            i < review.rating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Comment text
                  Text(
                    review.comment,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }






}