
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../appcolor.dart';
import '../../../string.dart';

enum StartingDayOfWeeks {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class Utils {
  const Utils._();

  static BoxDecoration get itemButtonDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.header_color),
      color: AppColors.header_color,
    );
  }

  static BoxDecoration get settingButtonDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      border: Border.all(
          color: AppColors.header_color
      ),
      color: AppColors.header_color,
    );
  }

  static BoxDecoration get settingButtonDecoration2 {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      border: Border.all(
          color: AppColors.newdark_gray
      ),
      color: AppColors.newdark_gray,
    );
  }

/*  static BoxDecoration get itemButtonLightGrayDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.light_grey),
      color: AppColors.light_grey,
    );
  }*/

  /*static BoxDecoration get itemButtonLightGrayDecoration1 {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
          color: AppColors.light_grey
      ),
      color: AppColors.newdark_gray,
    );
  }

  static BoxDecoration get itemBlureButtonDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.header_color),
      color: AppColors.header_color.withOpacity(0.1),
    );
  }

  static BoxDecoration get itemButtonBorderDecoration {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.header_color),
    );
  }*/

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
          (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

  static void loadingDialog() {
    Get.defaultDialog(
      radius: 5,
      barrierDismissible: false,
      title: "",
      titlePadding: EdgeInsets.zero,
      backgroundColor: AppColors.white,
      content: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: EdgeInsets.only(left: Get.width / 10, right: Get.width / 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoActivityIndicator(radius: 12),
              SizedBox(
                width: Get.width / 35,
              ),
              Text(
                "Please Wait .....",
                style: TextStyle(
                    color: AppColors.ligt_blck,
                    fontSize: Get.height / 55,
                    fontFamily: "Poppins-Bold"),
              )
            ],
          ),
        ),
      ),
    );
  }


  static void showCustomConfirmationDialog({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(
        fontFamily: "Poppins-Bold",
        fontSize: Get.height / 50,
        color: Colors.white,
      ),
      titlePadding: EdgeInsets.symmetric(vertical: 12),
      backgroundColor: backgroundColor,
      radius: 10,
      barrierDismissible: true,
      content: Column(
        children: [
          SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins-Regular",
              fontSize: Get.height / 60,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.back(); // Dismiss the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "OK",
                style: TextStyle(
                  fontFamily: "Poppins-Bold",
                  fontSize: Get.height / 60,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }




  static void fileuploadloadingDialog() {
    /*  double count=0.0;
    Timer.periodic(const Duration(seconds: 2), (Timer t) {
      count += 0.1;
      print(count);
    });
    AlertDialog(
      key: ValueKey(count),
      title: const Text("Loading..."),
      content: LinearProgressIndicator(
        value: count,
        backgroundColor: Colors.grey,
        color: Colors.green,
        minHeight: 10,
      ),
    );*/
    Get.defaultDialog(
      radius: 5,
      barrierDismissible: false,
      title: "",
      titlePadding: EdgeInsets.zero,
      backgroundColor: AppColors.white,
      content: Padding(
        padding: EdgeInsets.only(left: Get.width / 10, right: Get.width / 10),
        child: Container(
            child: Center(
                child: Image.asset(
                  "images/uploading.gif",
                  height: Get.height / 15,
                ))),
      ),
    );
  }

  static void closeDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

 /* static void shortToast(mesg) {
    Fluttertoast.showToast(
        backgroundColor: AppColors.app_color,
        textColor: AppColors.white,
        msg: mesg,

        fontSize: Get.height / 55,

        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }*/

  static void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  /*static void longToast(mesg) {
    Fluttertoast.showToast(
      msg: mesg,
      fontSize: Get.height / 45,
      backgroundColor: AppColors.red,
      textColor: AppColors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }*/

  static AppBar buildAppBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20, // Adjusted for better readability
          letterSpacing: 1.2, // Slightly increased spacing for a cleaner look
          color: Colors.black, // Ensure text contrasts well with the background
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.white, // Customize color to match your theme
      elevation: 4.0, // Slight elevation for depth
      shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for a modern look
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios, // Back button icon
          color: Colors.black, // Ensure the icon is visible on the background
        ),
        onPressed: () {
          Navigator.of(context).pop(); // Go back to the previous screen
        },
      ),
      actions: [
        /*IconButton(
          icon: Icon(
            Icons.notifications, // Notification icon
            color: Colors.white, // Ensure icon is visible on a blue background
          ),
          onPressed: () {
            // Handle notification icon press
          },
        ),
        IconButton(
          icon: Icon(
            Icons.search, // Search icon
            color: Colors.white,
          ),
          onPressed: () {
            // Handle search icon press
          },
        ),*/
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ), // Rounded corners for the AppBar
      ),
    );
  }

  static PreferredSize commonAppBar(String? title, {List<Widget>? action}) =>
      PreferredSize(
          preferredSize: Size.fromHeight( Get.width>550? 110:70),
          child: Container(
            margin: EdgeInsets.only(bottom: 0.0),
            alignment: Alignment.topCenter,
            height: 200,
            decoration: BoxDecoration(
                color: Color(0xffFFFAF8),
                boxShadow: [BoxShadow(color: Color(0xfffaf8f7), blurRadius: 5)],
                border: Border.all(color: AppColors.black.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: EdgeInsets.only(
                  top: Get.width>550? Get.height/30:0, left: Get.width / 20, right: Get.width / 20),
              child: AppBar(
                title: Text(
                  title!,
                  style: appBarSemiBoldStyle(),
                ),
                elevation: 0.0,
                backgroundColor: Color(0xffFFFAF8),
                centerTitle: true,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.light_black,
                    size: Get.height / 35,
                  ),
                ),
                actions: action,
              ),
            ),
          ));

  static PreferredSize commonDrawAppBar(title) {
    return PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          margin: EdgeInsets.only(bottom: 0.0),
          alignment: Alignment.topCenter,
          height: 200,
          decoration: BoxDecoration(
              color: Color(0xffFFFAF8),
              boxShadow: [BoxShadow(color: Color(0xfffaf8f7), blurRadius: 5)],
              border: Border.all(color: AppColors.black.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.only(
                top: Get.height / 20,
                left: Get.width / 20,
                right: Get.width / 20),
            child: AppBar(
              title: Text(
                title,
                style: appBarSemiBoldStyle(),
              ),
              elevation: 0.0,
              backgroundColor: Color(0xffFFFAF8),
              centerTitle: true,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.light_black,
                  size: Get.height / 35,
                ),
              ),
            ),
          ),
        ));
  }
  static AppBar comAppBar(title) {
    return AppBar(
      title:   Text(title,style: Utils.appBarSemiBoldStyle(),),
      centerTitle: true,
      backgroundColor:AppColors.white ,
      surfaceTintColor: Colors.transparent,
      leading: InkWell(
        onTap: (){
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
          size: Get.height/50,color: AppColors.black,
        ),
      ),

      elevation: 0.0,
    );
  }

  static void alertDialog(
      String? message, {
        VoidCallback? onTap,
        bool addWillPopScope = true,
      }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: !addWillPopScope
            ? null
            : () async {
          Get.back();

          onTap?.call();

          return true;
        },
        content: Text(message ?? Strings.somethingWentWrong,
            textAlign: TextAlign.center,
            maxLines: 6,
            style: TextStyle(color: AppColors.black)),
        confirm: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              //Get.offAllNamed(Routes.DASHBOARD);
              // Get.offAllNamed(Routes.DASHBOARD);

              onTap?.call();
            },
            child: Container(
              child: Text(
                'ok',
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ),
        ),
      );

  static void homeworksubmitbystudentalertDialog(
      String? message, {
        VoidCallback? onTap,
        bool addWillPopScope = true,
      }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: !addWillPopScope
            ? null
            : () async {
          Get.back();

          onTap?.call();

          return true;
        },
        content: Text(message ?? Strings.somethingWentWrong,
            textAlign: TextAlign.center,
            maxLines: 6,
            style: TextStyle(color: AppColors.black)),
        confirm: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              //Get.offAllNamed(Routes.DASHBOARD);
              Get.back();
              Get.back();
              Get.back();
              onTap?.call();
            },
            child: Container(
              child: Text(
                'ok',
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ),
        ),
      );

  static void homeworkcreatealertDialog(
      String? message, {
        VoidCallback? onTap,
        bool addWillPopScope = true,
      }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: !addWillPopScope
            ? null
            : () async {
          Get.back();
          onTap?.call();
          return true;
        },
        content: Text(message ?? Strings.somethingWentWrong,
            textAlign: TextAlign.center,
            maxLines: 6,
            style: TextStyle(color: AppColors.black)),
        confirm: Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              //Get.offAllNamed(Routes.DASHBOARD);
              // Get.offAllNamed(Routes.HOMEWORKCREATEDLISTTEACHER);

              onTap?.call();
            },
            child: Container(
              child: Text(
                'ok',
                style: TextStyle(color: AppColors.black),
              ),
            ),
          ),
        ),
      );

  static void closeSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.back();
    }
  }

  static void showSnackbar(String? message) {
    closeSnackbar();

    Get.rawSnackbar(message: message);
  }

  static void showDialog(
      String? message, {
        String title = Strings.message,
        bool success = false,
        VoidCallback? onTap,
        bool addWillPopScope = true,
      }) =>
      Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: !addWillPopScope
            ? null
            : () async {
          Get.back();

          onTap?.call();

          return true;
        },
        title: success ? Strings.success : title,
        content: Text(message ?? Strings.somethingWentWrong,
            textAlign: TextAlign.center,
            maxLines: 6,
            style: TextStyle(
                color: AppColors.black,
                fontSize: 17,
                fontFamily: "Poppins-SemiBold")),
        confirm: Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {
              Get.back();

              onTap?.call();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 30,
                width: 150,
                decoration: BoxDecoration(
                    color: AppColors.header_color,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 17,
                        fontFamily: "Poppins-SemiBold"),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
  /*Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: !addWillPopScope
            ? null
            : () async {
                Get.back();
                onTap?.call();
                return true;
              },
        title: success ? Strings.success : title,
        titleStyle: Utils.headingBoldStyle(),
        content: Text('Open link in browser?',
            textAlign: TextAlign.center,
            maxLines: 6,
            style: TextStyle(
                color: AppColors.black,
                fontSize: Get.height / 65,
                fontFamily: "Poppins-SemiBold")),
        confirm: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                  onTap?.call();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 30,
                    width: Get.width/6,
                    decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: Get.height / 65,
                            fontFamily: "Poppins-SemiBold"),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width / 30,
              ),
              InkWell(
                onTap: () {
                  launchURL(url);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 30,
                    width: Get.width/6,
                    decoration: BoxDecoration(
                        color: AppColors.header_color,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: Get.height / 65,
                            fontFamily: "Poppins-SemiBold"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );*/

  //=============================TextStyle Font and color ==============================//

/*---------------------text8---------------------*/
  static TextStyle textregular8sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 80:Get.height / 70,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle textmedium8sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 80:Get.height / 70,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textsemiBold8sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 80:Get.height / 70,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle textbold8sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 80:Get.height / 70,
        fontFamily: 'Poppins-Bold');
  }

/*---------------------text10---------------------*/

  static TextStyle textregular10sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle textregular10spcustomlightgrey() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle textmedium10sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle textmedium10spcustomlightgrey() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle textmedium10whitesp() {
    return TextStyle(
        color: AppColors.white,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle textmedium10spCustomLightGrey() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle green_textmedium10sp() {
    return TextStyle(
        color: AppColors.green_text,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle red_textmedium10sp() {
    return TextStyle(
        color: AppColors.red_text,
        fontSize:Get.width>550?Get.height / 75: Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textmedium10splight_grey() {
    return TextStyle(
        color: AppColors.light_grey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textmedium10spGray_text() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle textmedium10sp_header_color() {
    return TextStyle(
        color: AppColors.header_color,
        fontSize:Get.width>550?Get.height / 75: Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textsemiBold10sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle textbold10sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Bold');
  }

  static TextStyle textPoppins10sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins');
  }
  static TextStyle textPoppinslightGrey10sp() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins');
  }
/*---------------------text11---------------------*/
  static TextStyle textregular11sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  } static TextStyle textregularlightgray11sp() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.width>550?Get.height / 75:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  }
/*---------------------text12---------------------*/
  static TextStyle textregular12sp() {
    return TextStyle(
        color: AppColors.ligt_blck,

        fontSize: Get.width>550?Get.height / 75:Get.height / 60,
        fontFamily: 'Poppins-Regular');
  }
  static TextStyle textgreyregular12sp() {
    return TextStyle(
        color: AppColors.gray_text,

        fontSize: Get.width>550?Get.height / 75:Get.height / 60,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle textregular12sp_customlightgrey() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Regular');
  }
  static TextStyle textregular12splight_Liver_black() {
    return TextStyle(
        color: AppColors.light_Liver_black,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textmedium12sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  }
// Added by Vijay
  static TextStyle textfieldmedium12sp() {
    return TextStyle(
        color: AppColors.lite_black_color,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle gray_textmedium12sp() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle gray_textmedium14sp() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.width>550?Get.height / 50:Get.height / 40,
        fontFamily: 'Poppins-Medium');
  }
  //  added by Vijay
  static TextStyle whitetextmedium12sp() {
    return TextStyle(
        color: AppColors.customwhite,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle whitetextmedium14sp() {
    return TextStyle(
        color: AppColors.customwhite,
        fontSize: Get.width>550?Get.height / 50:Get.height / 40,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textMediumGray12sp() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textsemiBold12sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle textmedium12dsp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        height: 1.0,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textbold12sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins-Bold');
  }
  static TextStyle textregularlight12sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 70:Get.height / 60,
        fontFamily: 'Poppins');
  }

/*---------------------text14---------------------*/
  static TextStyle textregular14sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 65:Get.height / 55,
        fontFamily: 'Poppins-Regular');
  }  static TextStyle textregularThemeColor14sp() {
    return TextStyle(
        color: AppColors.header_color,
        fontSize: Get.width>550?Get.height / 65:Get.height / 55,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle textmedium14sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 65:Get.height / 55,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle textmediumlightgrey14sp() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.width>550?Get.height / 65:Get.height / 55,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle textsemiBold14sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 65:Get.height / 55,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle textbold14sp() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 65:Get.height / 55,
        fontFamily: 'Poppins-Bold');
  }

  /*---------------------text16---------------------*/
  static TextStyle text16SPRegular() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 60:Get.height / 50,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle text16SPMedium() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 60:Get.height / 50,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins-Medium');
  }  static TextStyle accountText16SPMedium() {
    return TextStyle(
        color: AppColors.light_grey,
        fontSize: Get.width>550?Get.height / 60:Get.height / 50,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle text16SPSemiBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 60:Get.height / 50,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle text16SPBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 60:Get.height / 50,
        fontFamily: 'Poppins-Bold');
  }

  /*---------------------text18---------------------*/
  static TextStyle text18SPRegular() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 55:Get.height / 45,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle text18SPMedium() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 55:Get.height / 45,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle text18SPSemiBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 55:Get.height / 45,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle text180SPBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 55:Get.height / 45,
        fontFamily: 'Poppins-Bold');
  }

  /*---------------------text20---------------------*/
  static TextStyle text20SPRegular() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 50:Get.height / 40,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle text20SPMedium() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 50:Get.height / 40,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle text20SPSemiBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 50:Get.height / 40,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle text20SPBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 50:Get.height / 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins-Bold');
  }

  /*---------------------text22---------------------*/
  static TextStyle text22SPRegular() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 45:Get.height / 35,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle text22SPMedium() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 45:Get.height / 35,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle text22SPSemiBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 45:Get.height / 35,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle text22SPBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 45:Get.height / 35,

        fontFamily: 'Poppins-Bold');
  }

/*---------------------text24---------------------*/
  static TextStyle text24SPRegular() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 40:Get.height / 30,
        fontFamily: 'Poppins-Regular');
  }

  static TextStyle text24SPMedium() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 40:Get.height / 30,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle text24SPSemiBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 40:Get.height / 30,
        fontFamily: 'Poppins-SemiBold');
  }

  static TextStyle text24SPBold() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 40:Get.height / 30,
        fontFamily: 'Poppins-Bold');
  }

  //=============================End==============================//

  static TextStyle urlUnderlineStyle() {
    return TextStyle(
      decoration: TextDecoration.underline,
      color: AppColors.crytl_blue,
      fontSize: Get.width>550?Get.height / 75:Get.height/65,
      fontFamily: 'Poppins-Medium',
    );
  }
  static TextStyle customlightgreyMediumStyle() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 60,
        fontFamily: "Poppins-Medium");
  }
  static TextStyle lightgreyMediumStyle() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: "Poppins-Medium");
  }
  static TextStyle aadharlightgreyMediumStyle() {
    return TextStyle(
        color: AppColors.light_grey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 40,
        fontWeight: FontWeight.bold,
        fontFamily: "Poppins-Medium");
  }

  static TextStyle headingBoldStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Bold');
  }

  static TextStyle headingBoldSecondStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle sideMenusStyle() {
    return TextStyle(
        color: AppColors.gray.withOpacity(0.7),
        fontSize: Get.width>550?Get.height / 75:Get.height / 45,
        fontFamily: 'Poppins-Regular');
  } static TextStyle selectSideMenusStyle() {
    return TextStyle(
        color: AppColors.buttoncolornew,
        fontSize: Get.width>550?Get.height / 75:Get.height / 35,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle mainHeadingStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 45,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle mainHeadingStyle1() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 30,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins-Bold');
  }

  static TextStyle mainHeadingStyleMedium() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.width>550?Get.height / 75:Get.height / 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins-Bold');
  }

  static TextStyle bookmarkStyle() {
    return TextStyle(
      color: AppColors.header_color,
      fontSize: Get.width>550?Get.height / 75:Get.height / 55,
      fontFamily: 'Poppins-Medium',
    );
  }

  static TextStyle selectDateStyle() {
    return TextStyle(
      color: AppColors.header_color,
      fontSize: Get.width>550?Get.height / 75:Get.height / 55,
      fontFamily: 'Poppins-Medium',
    );
  }

  static TextStyle normalStyle() {
    return TextStyle(
        color: AppColors.light_black,
        fontSize: Get.width>550?Get.height / 75:Get.height / 55,
        fontFamily: "Poppins-Regular");
  }
  static TextStyle nornalStyleHeaderColor10SpMedium() {
    return TextStyle(
      color: AppColors.header_color,
      fontSize: Get.width>550?Get.height / 75:Get.height / 65,
      fontFamily: 'Poppins-Medium',
    );
  }


  static TextStyle normalStyle5() {
    return TextStyle(
        color: AppColors.light_black,
        fontSize: Get.width>550?Get.height / 75:Get.height / 60,
        fontFamily: "Poppins-Regular");
  }


  static TextStyle conversationDescriptionStyle() {
    return TextStyle(
        color: AppColors.light_black,
        fontSize: Get.width>550?Get.height / 75:Get.height / 45,
        fontFamily: "Poppins-Medium");
  }

  //Added by Vijay
  static TextStyle normalStyle2() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: "Poppins-Regular");
  }

  //Added by Vijay
  static TextStyle customlightgreyStyle() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: "Poppins-Regular");
  }
  static TextStyle normalRedTextRegular10spStyle() {
    return TextStyle(
        color: AppColors.red,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: "Poppins-Regular");
  }

// added by vijay
  static TextStyle normalStyle1() {
    return TextStyle(
        color: AppColors.red_text,
        fontSize: Get.width>550?Get.height / 75:Get.height / 65,
        fontFamily: "Poppins-Medium");
  }

  static TextStyle dropDownNormalStyle() {
    return TextStyle(
      color: AppColors.gray_text,
      fontSize: Get.width>550?Get.height / 75:Get.height / 60,
      fontFamily: "Poppins-Medium",);
  }
  static TextStyle dropDownLiteStyle() {
    return TextStyle(
      color: AppColors.gray_text,
      fontSize: Get.width>550?Get.height / 75:Get.height / 65,
      fontFamily: "Poppins-Medium",);
  }

  static TextStyle dropDownBoldStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 75,
        fontFamily: "Poppins-Bold");
  }


  static TextStyle headingNormalBoldStyle(){
    return TextStyle(color: AppColors.ligt_blck, fontSize:Get.height/50,fontFamily: "Poppins-SemiBold");
  }
  static TextStyle normalBoldStyle(){
    return TextStyle(color: AppColors.ligt_blck,
        fontSize:Get.height/55,fontFamily: "Poppins-Bold",fontWeight: FontWeight.bold);
  }
/*--------------Setting Ui required-----------------*/
  static TextStyle normalBoldLiteBlackStyle(){
    return TextStyle(color: AppColors.gray_text, fontSize:Get.width>550?Get.height / 60:Get.height/55,fontFamily: "Poppins-Medium");
  }

  static TextStyle setting12SpReular(){
    return TextStyle(color: AppColors.gray_text, fontSize: Get.width>550?Get.height / 75:Get.height/60,fontFamily: "Poppins-Regular");
  }

  static TextStyle transport10SpMedium(){
    return TextStyle(color: AppColors.gray_text, fontSize:Get.width>550?Get.height / 75:Get.height/60,fontFamily: "Poppins-Medium");
  }
  static TextStyle transport10SpMediumLightGrey(){
    return TextStyle(color: AppColors.customlightgrey, fontSize:Get.width>550?Get.height / 75:Get.height/60,fontFamily: "Poppins-Medium");
  }

  static TextStyle setting10SpReular(){
    return TextStyle(color: AppColors.ligt_blck, fontSize:Get.width>550?Get.height / 75:Get.width>550?Get.height / 75:Get.height/60,fontFamily: "Poppins-Regular");
  }

  static TextStyle normalSemiBoldStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 60,
        fontFamily: "Poppins-Regular");
  }

  static TextStyle normalLiteStyle() {
    return TextStyle(
        color: AppColors.light_grey,
        fontSize: Get.height / 65,
        fontFamily: "Poppins-Regular");
  }

// Added by Vijay

  static TextStyle normalLiteStyle6() {
    return TextStyle(
        color: AppColors.lite_black_color,
        fontSize: Get.height / 65,
        fontFamily: "Poppins-Regular");
  }

  static TextStyle normalLiteStyleNotice() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.height / 65,
        fontFamily: "Poppins-Medium");
  }

  static TextStyle normalStyleNotice() {
    return TextStyle(
        color: AppColors.light_black,
        fontSize: Get.height / 60,
        fontFamily: "Poppins-Medium");
  }

  static TextStyle normalLightStyle() {
    return TextStyle(
        color: AppColors.customlightgrey,
        fontSize: Get.height / 65,
        fontFamily: "Poppins-Regular");
  }

  static TextStyle headingSemiBoldStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 65,
        fontFamily: "Poppins-SemiBold");
  }

  static TextStyle appBarSemiBoldStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 40,
        fontWeight: FontWeight.bold,
        fontFamily: "Poppins-Bold");
  }

  static TextStyle appBarSemiBoldStyle1() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 45,
        fontFamily: "NovaFlat-Regular");
  }

  static TextStyle headingMediumStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 65,
        fontFamily: "Poppins-Medium");
  }

  static TextStyle settingMenuStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 50,
        fontFamily: "Poppins-Medium");
  }

//--------------------popup Style---------------------------//
  static TextStyle popupMediumStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 50,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle popupmediumStyle() {
    return TextStyle(
        color: AppColors.white,
        fontSize: Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }
  static TextStyle popUpmediumStyle() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle popupTitleStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 50,
        fontFamily: 'Poppins-Bold');
  }

  static TextStyle popupnormalStyle() {
    return TextStyle(
        color: AppColors.ligt_blck,
        fontSize: Get.height / 55,
        fontFamily: "Poppins-Regular");
  }
  static TextStyle popupNormalStyle() {
    return TextStyle(
        color: AppColors.gray_text,
        fontSize: Get.height / 60,
        fontFamily: "Poppins-Regular");
  }

  static TextStyle popupSemiBoldStyle(Color color) {
    return TextStyle(
        color: color,
        fontSize: Get.height / 65,
        fontFamily: "Poppins-SemiBold");
  }
  static TextStyle deletepopupSemiboldStyle(Color color) {
    return TextStyle(
        color: color,
        fontSize: Get.height / 50,
        fontFamily: "Poppins-SemiBold");
  }

//----------------------------itemButtonTextStyle----------------------------------//
  static TextStyle itemButtonMediumStyle() {
    return TextStyle(
        color: AppColors.white,
        fontSize: Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }
  //Added by Vijay
  static TextStyle itemButtonMediumStyle5() {
    return TextStyle(
        color: AppColors.white,
        fontSize: Get.height / 55,
        fontFamily: 'Poppins-Medium');
  }
  //added by vijay
  static TextStyle itemButtonMediumStyle1() {
    return TextStyle(
        color: AppColors.settings_icon,
        fontSize: Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle itemButtonWhiteMediumStyle() {
    return TextStyle(
        color: AppColors.white,
        fontSize: Get.height / 40,
        fontFamily: 'Poppins-Medium');
  }


  static TextStyle itemButtonOrangeMediumStyle() {
    return TextStyle(
        color: Color(0xffed7c46),
        fontSize: Get.height / 65,
        fontFamily: 'Poppins-Medium');
  }

  static TextStyle itemButtonlightgreyMediumStyle() {
    return TextStyle(
        color: AppColors.light_grey,
        fontSize: Get.height / 65,
        height: 1.5,
        fontFamily: 'Poppins-Medium');
  }

  static String universalDateFormat(
      String day,
      String month,
      String year,
      ) {
    return DateFormat('dd').format(DateTime.parse(day)) +
        " " +
        DateFormat('MMM').format(DateTime.parse(month)) +
        " " +
        DateFormat('yyyy').format(DateTime.parse(year));
  }

  /*  Get.defaultDialog(
        barrierDismissible: false,
        onWillPop: !addWillPopScope
            ? null
            : () async {
                Get.back();

                onTap?.call();

                return true;
              },
        title: success ? Strings.success : title,
        titleStyle: Utils.headingBoldStyle(),
        content: Text(
          'Launch this link in a browser?',
          textAlign: TextAlign.center,
          maxLines: 6,
          style: TextStyle(
            color: AppColors.black,
            fontSize: Get.height / 65,
            fontFamily: "Poppins-SemiBold",
          ),
        ),
        confirm: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                  onTap?.call();
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                        color: AppColors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: Get.height / 65,
                            fontFamily: "Poppins-SemiBold"),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Get.width / 30,
              ),
              InkWell(
                onTap: () {
                  inapplaunchURL(url);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                        color: AppColors.header_color,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Okay',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: Get.height / 65,
                            fontFamily: "Poppins-SemiBold"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );*/

  /*static Future<void> showImagePicker({
    required Function(CroppedFile image) onGetImage,
  }) async {
    return showModalBottomSheet<void>(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
      ),
      backgroundColor: AppColors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gallery Option
              _buildPickerOption(
                icon: Icons.image,
                label: Strings.gallery,
                onTap: () async {
                  final image = await getImage(source: 2);
                  if (image != null) {
                    onGetImage(image);
                  }
                  Get.back();
                },
              ),
              // Camera Option
              _buildPickerOption(
                icon: Icons.camera,
                label: Strings.camera,
                onTap: () async {
                  final image = await getImage();
                  if (image != null) {
                    onGetImage(image);
                  }
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }*/

  /*static Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: AppColors.attempt_student),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }*/


  /*static Future<CroppedFile?> getImage({int source = 1}) async {
    CroppedFile? croppedFile;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == 1 ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 60,
    );
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      final image = File(pickedFile.path);
      croppedFile = await ImageCropper().cropImage(
          compressQuality: 50,
          sourcePath: image.path,
          // aspectRatioPresets: [
          //   CropAspectRatioPreset.square,
          //   CropAspectRatioPreset.ratio3x2,
          //   CropAspectRatioPreset.original,
          //   CropAspectRatioPreset.ratio4x3,
          //   CropAspectRatioPreset.ratio16x9
          // ],
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.transparent,
              toolbarWidgetColor: Colors.transparent,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              minimumAspectRatio: 0.1,
              aspectRatioLockDimensionSwapEnabled: true,
            ),
          ]);
    }
    return croppedFile;
  }*/


/*  static void inapplaunchURL(String? u) async {
    Get.back();
    Uri uri = Uri.parse(u!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
        // forceWebView: true,enableDomStorage: true,forceSafariVC: true,enableJavaScript: true
      );
    } else {
      throw 'Could not launch $uri';
    }
  }*/

 /* static BoxDecoration get commonDecoration {
    return BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.light_grey_border));
  }*/
  static BoxDecoration get commonDecorationsecond {
    return BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.light_black));
  }

  static Widget get ButtonCoinatiner {
    return Container(
        color: AppColors.white,
        decoration:  BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.light_black))

    );
  }

  /*static BoxDecoration get commonSGalleryDecoration {
    return BoxDecoration(
      border: Border.all(color: AppColors.button_color),
      borderRadius: BorderRadius.circular(5.0),
      shape: BoxShape.rectangle,
    );
  }*/

  static BoxDecoration get onBoxDecoration {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: AppColors.light_grey.withOpacity(0.4),
          blurRadius: 4,
          spreadRadius: 0.2,
          offset: Offset(0, 0),
        ),
      ],
    );
  }

  static BoxDecoration get onBoxDecoration1 {
    return BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.customlightgrey)

    );
  }
  static BoxDecoration get onschoolgallryBoxDecoration {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: AppColors.light_grey.withOpacity(0.8),
          blurRadius: 5,
          spreadRadius: 0.2,
          offset: Offset(0, 0),
        ),
      ],
    );
  }

/*
  static Future<Uri> createDynamicLink(id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://erpschool.page.link?userid=$id',
      link: Uri.parse('https://erpschool.page.link'),
      androidParameters: AndroidParameters(
        packageName: 'com.new_erp_school',
        minimumVersion: 22,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.mbd.erpschool',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
    );
    var dynamicUrl = parameters.longDynamicLink!;

    final Uri shortUrl = dynamicUrl;
    print("Url Link : " +shortUrl.toString());
    return shortUrl;
  }*/

  static Widget Function(
      BuildContext context,
      int index,
      Animation<double> animation,
      ) animationItemBuilder(
      Widget Function(int index) child, {
        EdgeInsets padding = EdgeInsets.zero,
      }) =>
          (
          BuildContext context,
          int index,
          Animation<double> animation,
          ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, -0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: padding,
                child: child(index),
              ),
            ),
          );

  static Widget Function(
      BuildContext context,
      Animation<double> animation,
      ) animationBuilder(
      Widget child, {
        double xOffset = 0,
        EdgeInsets padding = EdgeInsets.zero,
      }) =>
          (
          BuildContext context,
          Animation<double> animation,
          ) =>
          FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(animation),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(xOffset, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          );

 /* static commonDeletePopup(Widget? images, String msg, String msgs,
      Function()? onTap, Function()? onTapCancel) =>
      Get.bottomSheet(Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: Get.height / 16),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15)
              ),
              child: Material(
                child: Container(
                  width: Get.width,
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: Get.width / 20, right: Get.width / 20),
                      child: Column(
                        children: [
                          images!,
                          Text(msg,style: deletepopupSemiboldStyle(AppColors.button_color),),
                          SizedBox(height: Get.height / 80,),
                          Text(msgs,style: popupNormalStyle(),),
                          SizedBox(height: Get.height / 45,),
                          InkWell(
                            onTap: onTap,
                            child: Container(
                              height: Get.height / 20,
                              width: Get.width / 4,
                              decoration: BoxDecoration(color: AppColors.button_color,borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  "Delete",
                                  style: popupmediumStyle(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height / 45,
                          ),
                          InkWell(
                            onTap: onTapCancel,
                            child: Text(
                              "Cancel",
                              style: popUpmediumStyle(),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ));*/

 /* static commonBookmarkPopup(Widget? images, String msg, String msgs, Function()? onTap, Function()? onTapCancel,Widget text) =>
      Get.bottomSheet(Container(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: Get.height / 17),
            child: ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Material(
                child: Container(
                  width: Get.width,
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: Get.width / 20, right: Get.width / 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          images!,
                          Text(
                            msg,
                            style: deletepopupSemiboldStyle(
                                AppColors.button_color),
                          ),
                          SizedBox(height: Get.height / 80,),
                          Text(
                            msgs,
                            textAlign: TextAlign.center,
                            style: popupNormalStyle(),
                          ),
                          SizedBox(height: Get.height / 45,),
                          InkWell(
                            onTap: onTap,
                            child: Container(
                              height: Get.height / 20,
                              width: Get.width /3,
                              decoration: BoxDecoration(
                                color: AppColors.button_color,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                  child:text
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height / 45,
                          ),
                          InkWell(
                            onTap: onTapCancel,
                            child: Text(
                              "Cancel",
                              style: popUpmediumStyle(),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ));*/

}