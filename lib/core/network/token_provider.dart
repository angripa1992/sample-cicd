import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/network/public_rest_client.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/env/environment_variables.dart';

import '../../app/di.dart';
import '../../app/enums.dart';
import 'error_handler.dart';

class TokenProvider {
  // String? getAccessToken() => SessionManager().accessToke();

  String getAccessToken() => SessionManager().accessToke() ?? EMPTY;

  Future<Either<String, Failure>> fetchTokenFromServer() async {
    try {
      final response = await PublicRestClient().request(
        '${getIt.get<EnvironmentVariables>().baseUrl}${Urls.refreshToken}',
        Method.POST,
        {"refresh_token": SessionManager().refreshToken()},
      );
      final accessToken = response['access_token'];
      final refreshToken = response['refresh_token'];
      await SessionManager().saveToken(accessToken: accessToken, refreshToken: refreshToken);
      return Left(accessToken);
    } on DioException catch (error) {
      return Right(ErrorHandler.handle(error).failure);
    }
  }
}
