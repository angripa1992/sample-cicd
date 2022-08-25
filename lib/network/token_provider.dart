import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/app_preferences.dart';

class TokenProvider {
  final Dio _tokenDio = Dio()..options.baseUrl = "";
  final AppPreferences _appPreferences;
  String? _accessToken;
  String? _refreshToken;

  TokenProvider(this._appPreferences){
    loadTokenFromPreference();
  }

  void loadTokenFromPreference(){
    _accessToken = _appPreferences.getAccessToken();
    _refreshToken = _appPreferences.getRefreshToken();
  }

  void setAccessToken(String? token) {
    _accessToken = token;
    _appPreferences.setAccessToken(token);
  }

  void setRefreshToken(String? token) {
    _refreshToken = token;
    _appPreferences.setRefreshToken(token);
  }

  String? get accessToken => _accessToken;

  String? get refreshToken => _accessToken;

  Future<Either<String, int>> fetchTokenFromServer() async {
    try{
      final response = await _tokenDio.post('/token/refresh', data: {"refresh_token": _refreshToken});
      final accessToken = response.data['access_token'];
      final refreshToken = response.data['access_token'];
      setAccessToken(accessToken);
      setRefreshToken(refreshToken);
      return Left(accessToken);
    }on DioError catch (error){
      return Right(error.response?.statusCode ?? -1);
    }
  }
}
