import 'package:evcharging/app/module/qrcode/controller/qrcode_controller.dart';
import 'package:evcharging/app/module/qrcode/view/qrcode_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../appcolor.dart';
import '../../../../common/api/storage/storage.dart';
import '../../../../common/api/utils/utils.dart';
import '../../landingpage/controller/landingpage_controller.dart';
import '../../landingpage/view/ladningpage_view.dart';
import '../../nearbystation/controller/nearbystation_controller.dart';
import '../../nearbystation/view/nearbystation_view.dart';
import '../../stationlist/controller/stationlist_controller.dart';
import '../../stationlist/view/stationlist_view.dart';
import '../../stations/controller/station_controller.dart';
import '../../stations/view/stationn_view.dart';

class HomeController extends GetxController {
  final RxInt _changeIndex = 0.obs;

  int get changeIndex => _changeIndex.value;

  set changeIndex(int v) => _changeIndex.value = v;

  final RxString _title = 'Home'.obs;

  String get title => _title.value;

  set title(String v) => _title.value = v;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Widget homeViewScreen(String title) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title, style: Utils.appBarSemiBoldStyle()),
        centerTitle: false,
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu,
            size: Get.height / 25,
            color: AppColors.black,
          ),
        ),
        elevation: 1.0, // Slight elevation for a more modern look
      ),
      drawer: drawer(), // Drawer widget
      body: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.all(10), // Added padding for cleaner layout
        child: Obx(() => IndexedStack(index: changeIndex, children: body)),
      ),
    );
  }

  Widget drawer() {
    return SafeArea(
      child: Container(
        color: AppColors.white,
        width: Get.width / 1.5,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Drawer header
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 5,
                  right: Get.width / 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('images/evlogo1.png', height: Get.height / 20),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: Get.height / 25,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.dark_gray, thickness: 0.5),
              // Divider for visual separation

              // Home Section
              _drawerItem(
                icon: 'images/dashboard_icon.png',
                title: 'Home',
                onTap: () {
                  Get.back();
                  Get.find<LandingPageController>().onReady();
                  Get.find<LandingPageController>().onInit();
                  changeIndex = 0;
                  title = 'Home';
                },
              ),

              Divider(color: AppColors.dark_gray, thickness: 0.5),
              // Divider for visual separation
              // Nearby Stations (Map)
              _drawerItem(
                icon: 'images/placeholder.png',
                title: 'Nearby Stations',
                onTap: () {
                  Get.back();
                  /*Get.find<StationController>().onReady();
                  Get.find<StationController>().onInit();*/
                  Get.find<NearByStationController>().onReady();
                  Get.find<NearByStationController>().onInit();
                  changeIndex = 1;
                  title = 'Nearby Stations';
                },
              ),

              _drawerItem(
                icon: 'images/chargingstation.png',
                title: 'Qr Code',
                onTap: () {
                  changeIndex = 2;
                  Get.back();
                  Get.find<QrCodeController>().onReady();
                  Get.find<QrCodeController>().onInit();
                  //  Get.toNamed(Routes.STATION_LIST);
                  title = 'Qr Code';
                },
              ),

              // Station List
              _drawerItem(
                icon: 'images/chargingstation.png',
                title: 'All Charging Stations',
                onTap: () {
                  Get.back();
                  changeIndex = 3;
                  Get.find<StationListController>().onReady();
                  Get.find<StationListController>().onInit();
                  title = 'Charging Stations';
                },
              ),

              // Bookings
              _drawerItem(
                icon: 'images/car.png',
                title: 'My Bookings',
                onTap: () {
                  Get.back();
               //   Get.toNamed(Routes.BOOKING_HISTORY);
                  title = 'My Bookings';
                },
              ),

              _drawerItem(
                icon: 'images/logout.png',
                title: 'Log Out',
                onTap: () {
                  Get.defaultDialog(
                    title: "Confirm Logout",
                    middleText: "Are you sure you want to log out?",
                    textConfirm: "Yes",
                    textCancel: "No",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      // User confirmed logout
                      Get.back(); // Close dialog
                      Get.back(); // Close drawer (if needed)

                      // Clear token and navigate
                      //  Get.find<Prefs>().accessToken.val = '';
                      //  firebaseService.setUserLoginStatus(userDetials?.userid, false);
                      Storage.clearStorage();
                      //  Get.offAllNamed(Routes.SPLASH);
                    },
                    onCancel: () {
                      // User cancelled, just close dialog
                      Get.back();
                    },
                  );
                  /*  Get.back();
                  Get.find<Prefs>().accessToken.val = '';
                  Get.offAllNamed(Routes.SPLASH);
                  Storage.clearStorage();*/
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  final body = [LandingPageView(),NearbystationView(),QrCodeView(),StationListView()];

  Widget _drawerItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12), // Make the tap area rounded
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          // Remove default padding
          leading: Container(
            padding: EdgeInsets.all(8), // Add some padding to the icon
            decoration: BoxDecoration(
              color: AppColors.blue_color.withOpacity(0.2),
              // Subtle background for the icon
              borderRadius: BorderRadius.circular(8), // Rounded icon background
            ),
            child: Image.asset(
              icon,
              height: Get.height / 30, // Keep the size consistent
              color: AppColors.blue_color, // Ensure the color is appropriate
            ),
          ),
          title: Text(
            title,
            style: Utils.sideMenusStyle().copyWith(
              fontSize: 16, // Adjust font size to be more readable
              fontWeight: FontWeight.w600, // Ensure the text is bold enough
              color: AppColors.light_black, // Use a contrasting color
            ),
          ),
          onTap: onTap,
          // On tap callback
          trailing: Icon(
            Icons.arrow_forward_ios,
            // Optional: Add an arrow for better UI hint
            size: 16,
            color: AppColors.sidemenucolor,
          ),
        ),
      ),
    );
  }
}
