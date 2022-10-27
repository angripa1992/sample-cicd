import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/environment_variables.dart';

import '../../app/di.dart';
import 'dio_logger.dart';
import 'error_handler.dart';

class TokenProvider {
  final Dio _tokenDio = Dio();
  final DioLogger _dioLogger = DioLogger();
  final AppPreferences _appPreferences;
  //static String? _accessToken;
  //static String? _refreshToken;

  TokenProvider(this._appPreferences) {
    _initInterceptor();
    _tokenDio.options.baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
    loadTokenFromPreference();
  }

  void _initInterceptor() {
    _tokenDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (!kReleaseMode) {
            _dioLogger.logRequest(options);
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (!kReleaseMode) {
            _dioLogger.logResponse(response);
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (!kReleaseMode) {
            _dioLogger.logError(error);
          }
          return handler.next(error);
        },
      ),
    );
  }

  void loadTokenFromPreference() {
    // _accessToken = _appPreferences.retrieveAccessToken();
    // _refreshToken = _appPreferences.retrieveRefreshToken();

    // print('======after login======');
    // print('======access token -> $_accessToken======');
    // print('======refresh token -> $_refreshToken======');
  }

  void saveAccessToken(String? token) {
    //_accessToken = token;
    _appPreferences.insertAccessToken(token);
  }

  void saveRefreshToken(String? token) {
    //_refreshToken = token;
    _appPreferences.insertRefreshToken(token);
  }

  String? getAccessToken() => _appPreferences.retrieveAccessToken();

  String? getRefreshToken() => _appPreferences.retrieveRefreshToken();

  Future<Either<String, int>> fetchTokenFromServer() async {
    try {
      final response = await _tokenDio.post(Urls.refreshToken, data: {"refresh_token": getRefreshToken()});
      final accessToken = response.data['access_token'];
      final refreshToken = response.data['refresh_token'];
      saveAccessToken(accessToken);
      saveRefreshToken(refreshToken);
      return Left(accessToken);
    } on DioError catch (error) {
      return Right(error.response?.statusCode ?? ResponseCode.DEFAULT);
    }
  }
}
