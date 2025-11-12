import 'package:get/get.dart';

import '../module/addkhata/binding/addkhata_binding.dart';
import '../module/addkhata/view/addkhata_view.dart';
import '../module/addproduct/binding/addproduct_binding.dart';
import '../module/addproduct/view/addproduct_view.dart';
import '../module/home/binding/home_binding.dart';
import '../module/home/view/home_view.dart';
import '../module/khata/binding/customerledger_binding.dart';
import '../module/khata/binding/khata_binding.dart';
import '../module/khata/view/customer_ledger_screen.dart';
import '../module/khata/view/khata_view.dart';
import '../module/landingpage/binding/landingpage_binding.dart';
import '../module/landingpage/view/ladningpage_view.dart';
import '../module/nearbystation/binding/nearbystation_binding.dart';
import '../module/nearbystation/view/nearbystation_view.dart';
import '../module/productlist/binding/product_binding.dart';
import '../module/productlist/view/product_view.dart';
import '../module/qrcode/binding/qrcode_binding.dart';
import '../module/qrcode/view/qrcode_view.dart';
import '../module/report/binding/product_report_binding.dart';
import '../module/report/binding/report_dashboard_binding.dart';
import '../module/report/binding/sales_report_binding.dart';
import '../module/report/controller/product_report_controller.dart';
import '../module/report/view/product_report_view.dart';
import '../module/report/view/report_controller_view.dart';
import '../module/report/view/sales_report_view.dart';
import '../module/salepos/binding/salepos_binding.dart';
import '../module/salepos/view/salepos_view.dart';
import '../module/scanner/binding/scanner_binding.dart';
import '../module/scanner/view/scanner_view.dart';
import '../module/speechtotext/binding/sptext_binding.dart';
import '../module/speechtotext/view/sptext_view.dart';
import '../module/splash/binding/splash_binding.dart';
import '../module/splash/view/splash_view.dart';
import '../module/stationlist/binding/stationlist_binding.dart';
import '../module/stationlist/view/stationlist_view.dart';
import '../module/stations/binding/station_binding.dart';
import '../module/stations/view/stationn_view.dart';
import '../module/userinfor/binding/user_binding.dart';
import '../module/userinfor/view/user_view.dart';
import '../module/vendor/binding/vendor_binding.dart';
import '../module/vendor/view/vendor_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    /* GetPage(
  name: _Paths.LOGIN,
  page: () => const LoginView(),
  binding: LoginBinding(),
  ),*/
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LANDINGPAGE,
      page: () => const LandingPageView(),
      binding: LandingPageBinding(),
    ),
    GetPage(
      name: _Paths.VENDORNFO,
      page: () => const VendorView(),
      binding: VendorBinding(),
    ),
    GetPage(
      name: _Paths.USERINFO,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: _Paths.STATIONMARK,
      page: () => const StationView(),
      binding: StationBinding(),
    ),
    GetPage(
      name: _Paths.NEARBYSTATION,
      page: () => const NearbystationView(),
      binding: NearbystationBinding(),
    ),
    GetPage(
      name: _Paths.QRCODE,
      page: () => const QrCodeView(),
      binding: QrCodebinding(),
    ),
    GetPage(
      name: _Paths.SCANNERVIEW,
      page: () => const ScannerView(),
      binding: ScannerBinding(),
    ),
    GetPage(
      name: _Paths.STATIONLIST,
      page: () => const StationListView(),
      binding: StationListBinding(),
    ),
    GetPage(
      name: _Paths.STATION,
      page: () => const StationListView(),
      binding: StationListBinding(),
    ),
    GetPage(
      name: _Paths.SALEPOS,
      page: () => const ShopkeeperScreen(),
      binding: SaleposBinding(),
    ),
    GetPage(
      name: _Paths.KHATA,
      page: () => const KhataDashboard(),
      binding: KhataBinding(),
    ),
    GetPage(
      name: _Paths.ADDPRODUCT,
      page: () => const AddProductScreen(),
      binding: AddproductBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCTLIST,
      page: () => const ProductListScreen(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.REPORT,
      page: () => const ReportControllerView(),
      binding: ReportDashboardBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCTREPORT,
      page: () => const ProductReportView(),
      binding: ProductReportBinding(),
    ),
    GetPage(
      name: _Paths.SALEREPORT,
      page: () => const SalesReportView(),
      binding: SalesReportBinding(),
    ),
    GetPage(
      name: _Paths.SPTEXT,
      page: () => const SpeechPage(),
      binding: SptextBinding(),
    ),
    GetPage(
      name: _Paths.ADDKHATA,
      page: () => const AddKhataView(),
      binding: AddKhataBinding(),
    ),
    GetPage(
      name: _Paths.CUSTLEDGER,
      page: () =>  CustomerLedgerScreenState(),
      binding: CustomerledgerBinding(),
    ),
  ];
}
