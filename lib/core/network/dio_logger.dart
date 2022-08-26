import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioLogger {
  void logRequest(RequestOptions options) {
    _logPrint('*** API Request - Start ***');
    _printKV('URI', options.uri);
    _printKV('METHOD', options.method);
    _logPrint('HEADERS:');
    options.headers.forEach((key, v) => _printKV(' - $key', v));
    _logPrint('BODY:');
    _printAll(options.data ?? "");
    _logPrint('*** API Request - End ***');
  }

  void logResponse(Response response) {
    _logPrint('*** Api Response - Start ***');
    _printKV('URI', response.requestOptions.uri);
    _printKV('STATUS CODE', response.statusCode);
    _printKV('REDIRECT', response.isRedirect);
    _logPrint('BODY:');
    _printAll(response.data ?? "");
    _logPrint('*** Api Response - End ***');
  }

  void logError(DioError error) {
    _logPrint('*** Api Error - Start ***:');
    _logPrint('URI: ${error.requestOptions.uri}');
    if (error.response != null) {
      _logPrint('STATUS CODE: ${error.response?.statusCode?.toString()}');
    }
    _logPrint('$error');
    if (error.response != null) {
      _printKV('REDIRECT', error.response?.realUri);
      _logPrint('BODY:');
      _printAll(error.response?.toString());
    }
    _logPrint('*** Api Error - End ***:');
  }

  void _printKV(String key, dynamic v) {
    _logPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(_logPrint);
  }

  void _logPrint(String s) {
    debugPrint(s);
  }
}
