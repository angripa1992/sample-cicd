import 'package:klikit/app/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences{
  final SharedPreferences _preferences;
  final String _kAccessToken = "access_token";
  final String _kRefreshToken = "refresh_token";

  AppPreferences(this._preferences);

  void setAccessToken(String? token){
    _preferences.setString(_kAccessToken, token.orEmpty());
  }

  void setRefreshToken(String? token){
    _preferences.setString(_kRefreshToken, token.orEmpty());
  }

  String? getRefreshToken(){
    return _preferences.getString(_kRefreshToken);
  }

  String? getAccessToken(){
    return _preferences.getString(_kAccessToken);
  }

}