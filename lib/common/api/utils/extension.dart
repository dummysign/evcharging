
import 'package:evcharging/common/api/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/Constants.dart';
import '../data/app_error.dart';
import '../data/app_response.dart';
import '../data/interface.dart';

class Extensions {}

extension BorderRadiusExt on num {
  BorderRadius get borderRadius => BorderRadius.circular(0.0);

  InputBorder outlineInputBorder({
    BorderSide borderSide = BorderSide.none,
  }) =>
      OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: borderSide,
      );

  BorderSide borderSide({
    Color? color,
    double? width,
    BorderStyle? style,
  }) =>
      BorderSide(
        color: color ?? Colors.white,
        width: toDouble(),
        style: style ?? BorderStyle.solid,
      );
}

extension HexColorExt on String {
  Color get fromHex {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) {
      buffer.write('ff');
    }

    if (startsWith('#')) {
      buffer.write(replaceFirst('#', ''),);
    }
    return Color(int.parse(buffer.toString(), radix: 16),);
  }
}

extension ColorCode on String {
  Color get colorCode => Color(
    0xff +
        int.parse(
          split('#').last,
          radix: 16,
        ),
  );
}

extension ImageExt on String {
  String get image => 'assets/images/$this.png';

  Image imageAsset({
    Size? size,
    BoxFit? fit,
    Color? color,
  }) =>
      Image.asset(
        this,
        color: color,
        width: size?.width,
        height: size?.height,
        fit: fit,
      );
}

extension FutureExt<T> on Future<Response<T>?> {
  void futureValue(
      Function(T value) response, {
        Function(String? error)? onError,
        VoidCallback? retryFunction,
      }) {
    final _interface = Get.find<ApiInterfaceController>();
    _interface.error = null;
    timeout(
      Constants.timeout,
      onTimeout: () {

        Utils.showSnackbar(TimeoutError().message);
        if (retryFunction != null) {
          _interface.retry = retryFunction;
        }

        throw TimeoutError();
      },
    ).then((value) {
      final result = AppResponse.getResponse(value!);
    //  printInfo(info: 'bodyASSETRESPONSE: $value');
      response(result!);
    }).catchError((e) {
      final isAppError = e is AppErrors;
      final String? errorMessage = isAppError ? e.message : e.toString();

      /*Utils.showDialog(
        errorMessage,
        onTap: errorMessage != UnauthorizeError().message
            ? null
            : () {
                Storage.clearStorage();

              },
      );*/
      //Utils.shortToast(errorMessage);
      Utils.closeDialog();
      if (onError != null) {
        Utils.closeDialog();
        onError(errorMessage);
      }

      /*  if (e is NoConnectionError || e is TimeoutError) {
        _interface.error = e;

        if (retryFunction != null) {
          _interface.retry = retryFunction;
        }
      }*/

      printError(info: 'catchError: error: $e\nerrorMessage: $errorMessage');
    });
  }
}

extension AlignWidgetExt on Widget {
  Widget align({
    Alignment alignment = Alignment.center,
  }) =>
      Align(
        alignment: alignment,
        child: this,
      );
}

extension FormatDurationExt on int {
  String formatDuration() {
    final min = this ~/ 60;
    final sec = this % 60;
    return "${min.toString().padLeft(2, "0")}:${sec.toString().padLeft(2, "0")} min";
  }
}

extension DebugLog on String {
  void debugLog() {
    return debugPrint(
      '\n******************************* DebugLog *******************************\n'
          ' $this'
          '\n******************************* DebugLog *******************************\n',
      wrapWidth: 1024,
    );
  }
}