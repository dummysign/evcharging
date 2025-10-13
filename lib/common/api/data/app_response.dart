

import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../../../string.dart';
import 'app_error.dart';

class AppResponse {
  static T? getResponse<T>(Response<T> response) {
    final status = response.status;
    if (status.connectionError) {
      throw NoConnectionError();
    }
    try {
      final res = jsonDecode(response.bodyString!);
      if (response.isOk) {
        if (res is Map &&
            res['status'] != null &&
            (
                (res['status'] is bool && !res['status']) ||
                    (res['status'] is String && res['status'] != 'success' && res['status'] != '200')
            )){
          if (res['message'] != null &&
              res['message'].toString().isNotEmpty) {
            throw ApiError(
              message: res['message'].toString() ,
            );
          } else {
            throw ApiError(
              message: res['message'].toString(),
            );
          }
        }

        return response.body;
      } else {
        if (status.isServerError) {
          throw ApiError();
        }
        else if (status.code == HttpStatus.requestTimeout) {
          //  throw TimeoutError();
        }
        else if (response.unauthorized) {
          throw UnauthorizeError(
            message: res['message']?.toString() ?? Strings.unauthorize,
          );
        } else {
          throw ApiError(
            message: res['message']?.toString() ?? Strings.unknownError,
          );
        }
      }
    } on FormatException catch (e) {
      throw ApiError(message: e.toString(),);
    }
    on TimeoutException catch (e) {
      throw TimeoutError(
        message: e.message?.toString() ?? Strings.connectionTimeout,
      );
    }
    return null;
  }
}