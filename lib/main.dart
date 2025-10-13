import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/route/app_pages.dart';
import 'appcolor.dart';
import 'common/api/utils/initializer.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('Error : $details');
  };

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarBrightness: Brightness.light,
      statusBarIconBrightness:Brightness.light,
      statusBarColor: AppColors.app_color,
    ),
  );

  Initializer.instance.init(() {
    runApp(
      GetMaterialApp(
        title: "Application",
        debugShowCheckedModeBanner: false,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  });
}


