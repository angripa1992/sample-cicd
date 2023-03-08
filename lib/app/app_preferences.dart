import 'dart:convert';

import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../printer/data/printer_setting.dart';

class AppPreferences {
  final SharedPreferences _preferences;
  final String _kAccessToken = "access_token";
  final String _kRefreshToken = "refresh_token";
  final String _kUser = "user";
  final String _kLoggedIn = "logged_in";
  final String _kLoginEmail = "login_email";
  final String _kPrinterSetting = "printer_setting";
  final String _kLanguage = "language";

  AppPreferences(this._preferences);

  void insertAccessToken(String? token) {
    _preferences.setString(_kAccessToken, token.orEmpty());
  }

  void insertRefreshToken(String? token) {
    _preferences.setString(_kRefreshToken, token.orEmpty());
  }

  String? retrieveRefreshToken() {
    return _preferences.getString(_kRefreshToken);
  }

  String? retrieveAccessToken() {
    return _preferences.getString(_kAccessToken);
  }

  Future<void> saveUser(UserInfo user) async {
    await _preferences.setString(_kUser, json.encode(user));
  }

  UserInfo? getUser() {
    final preferenceData = _preferences.getString(_kUser);
    if (preferenceData == null) return null;
    final data = json.decode(preferenceData);
    return UserInfo.fromJson(data);
  }

  Future<void> setLoginState(bool isLoggedIn) async {
    await _preferences.setBool(_kLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _preferences.getBool(_kLoggedIn) ?? false;
  }

  Future<void> saveLoginEmail(String email) async {
    _preferences.setString(_kLoginEmail, email);
  }

  String loginEmail() {
    return _preferences.getString(_kLoginEmail) ?? EMPTY;
  }

  Future<void> saveLanguageCode(String languageCode) {
    return _preferences.setString(_kLanguage, languageCode);
  }

  String languageCode() {
    return _preferences.getString(_kLanguage) ?? 'en';
  }

  Future<void> savePrinterSettings({
    required PrinterSetting printerSetting,
  }) async {
    _preferences.setString(_kPrinterSetting, jsonEncode(printerSetting));
  }

  PrinterSetting printerSetting() {
    final preferenceData = _preferences.getString(_kPrinterSetting);
    if (preferenceData == null) {
      return PrinterSetting(
        branchId: ZERO,
        connectionType: ConnectionType.BLUETOOTH,
        paperSize: RollId.mm80,
        customerCopyEnabled: FALSE,
        kitchenCopyEnabled: FALSE,
        customerCopyCount: ZERO,
        kitchenCopyCount: ZERO,
      );
    }
    final data = json.decode(preferenceData);
    return PrinterSetting.fromJson(data);
  }

  Future<void> clearPreferences() async {
    await _preferences.remove(_kAccessToken);
    await _preferences.remove(_kRefreshToken);
    await _preferences.remove(_kUser);
    await _preferences.remove(_kPrinterSetting);
  }
}
