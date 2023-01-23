import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/environment_variables.dart';

import '../../app/di.dart';
import '../provider/order_information_provider.dart';
import '../route/routes.dart';
import '../route/routes_generator.dart';
import 'dio_logger.dart';
import 'error_handler.dart';

class TokenProvider {
  final Dio _tokenDio = Dio();
  final DioLogger _dioLogger = DioLogger();
  final AppPreferences _appPreferences;

  TokenProvider(this._appPreferences) {
    _initInterceptor();
    _tokenDio.options.baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
  }

  void _initInterceptor() {
    _tokenDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _dioLogger.logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _dioLogger.logResponse(response);
          return handler.next(response);
        },
        onError: (error, handler) {
          _dioLogger.logError(error);
          return handler.next(error);
        },
      ),
    );
  }

  void _logout() {
    getIt.get<OrderInformationProvider>().clearData();
    getIt.get<AppPreferences>().clearPreferences().then(
      (value) {
        Navigator.pushNamedAndRemoveUntil(
            RoutesGenerator.navigatorKey.currentState!.context,
            Routes.login,
            (route) => false);
      },
    );
  }

  void saveAccessToken(String? token) {
    _appPreferences.insertAccessToken(token);
  }

  void saveRefreshToken(String? token) {
    _appPreferences.insertRefreshToken(token);
  }

  String? getAccessToken() => _appPreferences.retrieveAccessToken();

  String? getRefreshToken() => _appPreferences.retrieveRefreshToken();

  Future<Either<String, int>> fetchTokenFromServer() async {
    try {
      final response = await _tokenDio
          .post(Urls.refreshToken, data: {"refresh_token": getRefreshToken()});
      final accessToken = response.data['access_token'];
      final refreshToken = response.data['refresh_token'];
      saveAccessToken(accessToken);
      saveRefreshToken(refreshToken);
      return Left(accessToken);
    } on DioError catch (error) {
      if (error.response?.statusCode == ResponseCode.UNAUTHORISED) {
        _logout();
        return Right(error.response?.statusCode ?? ResponseCode.UNAUTHORISED);
      }
      return Right(error.response?.statusCode ?? ResponseCode.DEFAULT);
    }
  }
}
