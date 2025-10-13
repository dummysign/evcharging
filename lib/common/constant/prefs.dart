
import 'package:get_storage/get_storage.dart';

class Prefs {
  final apiKey = ''.val('apiKey');
  final accessToken = ''.val('accessToken');
  final profileImage = ''.val('profileImage');
  final onlineMode = ''.val('onlineMode');
  final partner = ''.val('partner');
  final phone = ''.val('phone');
  final user = ''.val('user');
  final remember = false.val('rememeber');
  final selectedTab = 1.val('selectedTab');
  final fcmToken = "".val('fcmToken');
  final location = "".val('location');
  final address = "".val('address');
  final latestVersion = "1.0.28".val('latestVersion');

  clear() {
    accessToken.val = "";
    phone.val = "";
    apiKey.val = "";
  }
}