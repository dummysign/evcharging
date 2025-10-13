

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../../widget/station_card.dart';
import '../controller/stationlist_controller.dart';

class StationListView extends GetView<StationListController>{
  const StationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final stations = controller.stationlist;

        if (stations.isEmpty) {
          return const Center(child: Text("No stations found."));
        }

        return ListView.builder(
          itemCount: stations.length,
          itemBuilder: (context, index) {
            final station = stations[index];
            return StationCard(station: station); // ✅ Reusable card
          },
        );
      }),
    );
  }

}