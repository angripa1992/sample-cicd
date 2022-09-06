import 'dart:convert';

import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences{
  final SharedPreferences _preferences;
  final String _kAccessToken = "access_token";
  final String _kRefreshToken = "refresh_token";
  final String _kUser = "user";
  final String _kLoggedIn = "logged_in";
  final String _kLoginEmail = "login_email";

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
  
  Future<void> saveUser(User user) async{
    await _preferences.setBool(_kLoggedIn, true);
    await _preferences.setString(_kUser, json.encode(user));
  }
  
  User getUser() {
    final preferenceData = _preferences.getString(_kUser);
    final data = json.decode(preferenceData!);
    return User.fromJson(data);
  }

  bool isLoggedIn(){
    return _preferences.getBool(_kLoggedIn) ?? false;
  }

  Future<void> saveLoginEmail(String email) async{
    _preferences.setString(_kLoginEmail, email);
  }

  String getLoginEmail() {
    return _preferences.getString(_kLoginEmail) ?? EMPTY;
  }

  Future<void> clearPreferences() async{
    await _preferences.remove(_kAccessToken);
    await _preferences.remove(_kRefreshToken);
    await _preferences.remove(_kUser);
    await _preferences.remove(_kLoggedIn);
  }
}