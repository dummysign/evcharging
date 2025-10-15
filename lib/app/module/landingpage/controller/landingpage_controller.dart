
import 'package:get/get.dart';

import '../../../route/app_pages.dart';

class LandingPageController extends GetxController{



   void onOptionTag(String tabKey) {
     switch (tabKey) {
       case 'Charging Stations':
         Get.toNamed(Routes.VENDORNFO);
         break;
       case 'User':
         Get.toNamed(Routes.STATIONMARK);
         break;
       case 'NEW SALE':
         Get.toNamed(Routes.SALEPOS);
         break;
       case 'ADD PRODUCT':
         Get.toNamed(Routes.ADDPRODUCT);
         break;
       case 'PRODUCT':
         Get.toNamed(Routes.PRODUCTLIST);
         break;
       case 'REPORT':
         Get.toNamed(Routes.REPORT);
         break;
       default:
         Get.snackbar('Unknown', 'Unknown tab: $tabKey');
     }


   }


}