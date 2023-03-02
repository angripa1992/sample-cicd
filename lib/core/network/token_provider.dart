import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/environment_variables.dart';

import '../../app/di.dart';
import 'dio_logger.dart';
import 'error_handler.dart';

class TokenProvider {
  final Dio _tokenDio = Dio();
  final DioLogger _dioLogger = DioLogger();

  TokenProvider() {
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

  String? getAccessToken() => SessionManager().accessToke();

  String? getRefreshToken() => SessionManager().refreshToken();

  Future<Either<String, int>> fetchTokenFromServer() async {
    try {
      final response = await _tokenDio.post(
        Urls.refreshToken,
        data: {"refresh_token": getRefreshToken()},
      );
      final accessToken = response.data['access_token'];
      final refreshToken = response.data['refresh_token'];
      await SessionManager().saveToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      return Left(accessToken);
    } on DioError catch (error) {
      if (error.response?.statusCode == ResponseCode.UNAUTHORISED) {
        SessionManager().logout();
        return Right(error.response?.statusCode ?? ResponseCode.UNAUTHORISED);
      }
      return Right(error.response?.statusCode ?? ResponseCode.DEFAULT);
    }
  }
}
