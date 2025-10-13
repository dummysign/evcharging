import 'package:get_storage/get_storage.dart';

import '../../constant/Constants.dart';

class Storage {
  const Storage._();

  static final GetStorage _storage = GetStorage();



  static GetStorage get storage => _storage;
  static Future<void> saveValue(String key, dynamic value) =>
      _storage.writeIfNull(key, value);

  static T? getValue<T>(String key) => _storage.read<T>(key);

  static bool hasData(String key) => _storage.hasData(key);

  static Future<void> removeValue(String key) => _storage.remove(key);

  static Future<void> clearStorage() => _storage.erase();



  //   static VerifyOtpResponse? get userData {
  //   final d = _storage.read(Constants.VERIFY_OTP);
  //   if (d != null) {
  //     if (d is VerifyOtpResponse) {
  //       return d;
  //     } else {
  //       return VerifyOtpResponse.fromJson(d);
  //     }
  //   }
  //   return null;
  // }

 /* static LoginResponse? get userDetails {
    final d = _storage.read(Constants.USER_DETAILS);
    if (d != null) {
      if (d is LoginResponse) {
        return d;
      } else {
        return LoginResponse.fromJson(d);
      }
    }
    return null;
  }*/

  static Future<void> saveBaseUrl(String url) async =>
      _storage.write(Constants.BASE_URL_KEY, url);

  static Future<void> saveBaseClient(String url) async =>
      _storage.write(Constants.BASE_CLIENT_TYPE, url);


  static Future<void> saveGeoFence(String url) async =>
      _storage.write(Constants.BASE_GEO_TYPE, url);

  static String? get baseUrl => _storage.read(Constants.BASE_URL_KEY);
  static String? get baseclient => _storage.read(Constants.BASE_CLIENT_TYPE);
  static String? get geofence => _storage.read(Constants.BASE_GEO_TYPE);



/*static RegisterNewUserResponse? get registerUserData {
    final d = _storage.read(Constants.REGISTER_USER_DATA);
    if (d != null) {
      if (d is RegisterNewUserResponse) {
        return d;
      } else {
        return RegisterNewUserResponse.fromJson(d);
      }
    }
    return null;
  }*/
}