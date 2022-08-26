import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/environment_variables.dart';

import '../../app/di.dart';
import 'error_handler.dart';


class TokenProvider {
  final Dio _tokenDio = Dio();
  final AppPreferences _appPreferences;
  static String? _accessToken;
  static String? _refreshToken;

  TokenProvider(this._appPreferences){
    _tokenDio.options.baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
    loadTokenFromPreference();
  }

  void loadTokenFromPreference(){
    _accessToken = _appPreferences.retrieveAccessToken();
    _refreshToken = _appPreferences.retrieveRefreshToken();
  }

  void saveAccessToken(String? token) {
    _accessToken = token;
    _appPreferences.insertAccessToken(token);
  }

  void saveRefreshToken(String? token) {
    _refreshToken = token;
    _appPreferences.insertRefreshToken(token);
  }

  String? get accessToken => _accessToken;

  String? get refreshToken => _accessToken;

  Future<Either<String, int>> fetchTokenFromServer() async {
    try{
      final response = await _tokenDio.post(Urls.refreshToken, data: {"refresh_token": _refreshToken});
      final accessToken = response.data['access_token'];
      final refreshToken = response.data['refresh_token'];
      saveAccessToken(accessToken);
      saveRefreshToken(refreshToken);
      return Left(accessToken);
    }on DioError catch (error){
      return Right(error.response?.statusCode ?? ResponseCode.DEFAULT);
    }
  }
}
