import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../appcolor.dart';
import '../data/stationdetails.dart';

class StationCard extends StatelessWidget {
  final DetailsResponse station;

  const StationCard({Key? key, required this.station}) : super(key: key);

  String _formatTime(String time) {
    if (time.contains('TimeOfDay(')) {
      return time.replaceAll('TimeOfDay(', '').replaceAll(')', '');
    }
    return time;
  }

  void _openMap(BuildContext context) async {
    final lat = station.latitude;
    final lng = station.longitude;

    if (lat != null && lng != null && lat.isNotEmpty && lng.isNotEmpty) {
      final uri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open Google Maps.';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safely handle all fields
    final imageUrl = "http://157.20.51.113/apitesteams${station.stationimage ?? ''}";
    final stationName = station.stationname?? 'Unnamed';
    final openTime = _formatTime(station.opentime ?? '');
    final closeTime = _formatTime(station.closetime?? '');
    final contact = station.mobileno ?? '';
    final facilities = [
      station.extrafacilities1 ?? '',
      station.extrafacilities2 ?? '',
      station.extrafacilities3 ?? '',
      station.extrafacilities4 ?? '',
    ].where((f) => f != null && f.toString().isNotEmpty).join(', ');

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Station Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                  ),
                ),
                const SizedBox(width: 12),
                // Name + Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stationName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("Open: $openTime - $closeTime"),
                    ],
                  ),
                ),
              ],
            ),
             SizedBox(height: 8),
            // Facilities
            if (facilities.isNotEmpty)
              Text("Facilities: $facilities"),
             SizedBox(height: 6),
            // Contact
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Contact: $contact"),
                IconButton(
                  icon: Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    if (contact.isNotEmpty) {
                      launchUrl(Uri.parse("tel:$contact"));
                    }
                  },
                ),
              ],
            ),
             SizedBox(height: Get.height * 0.01),
            // Show on Map Button
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: Get.height * 0.2,
                child: ElevatedButton.icon(
                  onPressed: () => _openMap(context),
                  style: ElevatedButton.styleFrom(
                    padding:  EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.app_color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  icon:  Icon(Icons.map),
                  label:  Text("Show on Map",style: TextStyle(color: AppColors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
