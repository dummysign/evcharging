import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prefs/prefs.dart';

import '../../../app/widget/customErrorWidget.dart';
import '../data/ApiHelper.dart';
import '../data/api_helper_impl.dart';
import '../data/interface.dart';


class Initializer{
  static final Initializer instance = Initializer._internal();
  factory Initializer() => instance;
  Initializer._internal();

  void init(VoidCallback runApp) async {

    ErrorWidget.builder = (errorDetails) {
      return CustomErrorWidget(
        message: errorDetails.exceptionAsString(),
      );
    };

    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      FlutterError.onError = (details) {
        FlutterError.dumpErrorToConsole(details);
        printInfo(info: details.stack.toString(),);
      };

      await _initServices();
      runApp();
    }, (error, stack) {
      printInfo(info: 'runZonedGuarded: ${stack.toString()}');
    });
  }


  Future<void> _initServices() async {
    try {
      await _initStorage();
      _initScreenPreference();
      _initApis();
    } catch (err) {
      rethrow;
    }
  }

  void _initApis() {
    Get.put<ApiHelper>(
      ApiHelperImpl(),);
    Get.put(Prefs(),);
    Get.put<ApiInterfaceController>(
      ApiInterfaceController(),);
  }

  Future<void> _initStorage() async {
    await GetStorage.init();
  }

  void _initScreenPreference() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}