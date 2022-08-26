import 'package:klikit/app/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences{
  final SharedPreferences _preferences;
  final String _kAccessToken = "access_token";
  final String _kRefreshToken = "refresh_token";

  AppPreferences(this._preferences);

  void insertAccessToken(String? token){
    _preferences.setString(_kAccessToken, token.orEmpty());
  }

  void insertRefreshToken(String? token){
    _preferences.setString(_kRefreshToken, token.orEmpty());
  }

  String? retrieveRefreshToken(){
    return _preferences.getString(_kRefreshToken);
  }

  String? retrieveAccessToken(){
    return _preferences.getString(_kAccessToken);
  }

}