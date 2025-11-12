part of 'app_pages.dart';
abstract class Routes{
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LANDINGPAGE = _Paths.LANDINGPAGE;
  static const USERINFO = _Paths.USERINFO;
  static const VENDORNFO = _Paths.VENDORNFO;
  static const STATIONMARK = _Paths.STATIONMARK;
  static const HOMEPAGE = _Paths.HOMEPAGE;
  static const NEARBYSTATION = _Paths.NEARBYSTATION;
  static const QRCODE = _Paths.QRCODE;
  static const SCANNERVIEW = _Paths.SCANNERVIEW;
  static const STATIONLIST = _Paths.STATIONLIST;
  static const STATION = _Paths.STATION;
  static const SALEPOS = _Paths.SALEPOS;
  static const KHATA = _Paths.KHATA;
  static const ADDPRODUCT = _Paths.ADDPRODUCT;
  static const PRODUCTLIST = _Paths.PRODUCTLIST;
  static const REPORT = _Paths.REPORT;
  static const PRODUCTREPORT = _Paths.PRODUCTREPORT;
  static const SALEREPORT = _Paths.SALEREPORT;
  static const SPTEXT = _Paths.SPTEXT;
  static const ADDKHATA = _Paths.ADDKHATA;
  static const CUSTLEDGER = _Paths.CUSTLEDGER;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LANDINGPAGE = '/landing';
  static const USERINFO = '/userinfo';
  static const VENDORNFO = '/vendorinfo';
  static const STATIONMARK = '/stationmark';
  static const HOMEPAGE = '/homepage';
  static const NEARBYSTATION = '/nearbystation';
  static const QRCODE = '/qrcode';
  static const SCANNERVIEW = '/scannerview';
  static const STATIONLIST = '/stationlist';
  static const STATION = '/station';
  static const SALEPOS = '/salepos';
  static const KHATA = '/khata';
  static const ADDPRODUCT = '/addproduct';
  static const PRODUCTLIST = '/productlist';
  static const REPORT = '/report';
  static const PRODUCTREPORT = '/productreport';
  static const SALEREPORT = '/salereport';
  static const SPTEXT = '/sptext';
  static const ADDKHATA  = '/addkhata';
  static const CUSTLEDGER  = '/custledger';
}