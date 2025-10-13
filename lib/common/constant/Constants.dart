class Constants {
  const Constants._();
// BASE URL only working office network
  // static const String BASE_URL = 'http://103.129.97.32/APIeams/EamsApi.svc/';
  // static const String BASE_URL = 'https://asset.hitachi-cashms.com/apieams/EamsApi.svc/';
  static  String BASE_URL = "";
// static const String BASE_URL = 'http://10.0.8.245/erplive/api/v2/';
// static const String BASE_URL = 'http://10.0.8.245/erpbeta/api/';
  static const String CHATBOAT_BASE_URL = 'https://chatbot.aasoka.com/';
  // todo=====* Note: E-Vox Base Url *======
  static const String E_VOX_BASE_URL = 'https://ell.adurox.com/mbd-api/';
  // todo=====* Note: base Url Of Ask Question *======
  static const String ASK_QUESTION_BASE_URL = 'http://10.0.8.246:5000/';
// todo=====* Note: before deploy need to update latest version *======
  static const String LATEST_VERSION = '1.0.28';
// todo=====* BASE URL Working all Networks *======
//  static const String BASE_URL = 'https://alts.aasoka.com/api/v2/';

  //call method channel only android for native code
  // static const platformMethodChannel = MethodChannel('com.new_erp_school/erpnative');
  static const String nativeMessage = '';
  static const timeout = Duration(minutes: 8);
  static const String VERIFY_OTP='verify_otp';
  static const String USER_DETAILS='user_details';
  static const String REGISTER_USER_DATA='registerUserData';
  static const String SESSION_COSTNAME='selectedCostName';
  static const String SESSION_COSTID='selectedCostid';
  static const String BASE_URL_KEY = "base_url";
  static const String BASE_CLIENT_TYPE = "client_type";
  static const String BASE_GEO_TYPE = "geo_type";
  static const String Clientname = "clientname";
}