import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/network/public_rest_client.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/env/environment_variables.dart';

import '../../app/di.dart';
import '../../app/enums.dart';
import 'error_handler.dart';

class TokenProvider {
  // TokenProvider() {
  //   _initInterceptor();
  //   _tokenDio.options.baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
  // }
  //
  // void _initInterceptor() {
  //   _tokenDio.interceptors.add(
  //     PrettyDioLogger(
  //       requestHeader: true,
  //       requestBody: true,
  //       responseBody: true,
  //       responseHeader: false,
  //       error: true,
  //       compact: true,
  //       maxWidth: 90,
  //     ),
  //   );
  // }

  String? getAccessToken() => SessionManager().accessToke();

  String? getRefreshToken() => SessionManager().refreshToken();

  Future<Either<String, int>> fetchTokenFromServer() async {
    try {
      final response = await PublicRestClient().request(
        '${getIt.get<EnvironmentVariables>().baseUrl}${Urls.refreshToken}',
        Method.POST,
        {"refresh_token": getRefreshToken()},
      );
      final accessToken = response['access_token'];
      final refreshToken = response['refresh_token'];
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
