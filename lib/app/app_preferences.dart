import 'dart:convert';

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
  final String _kPrinterConnectionType = "printer_connection_type";
  final String _kPrinterPaperSize = "printer_paper_size";
  final String _kDocketType = "docket_type";
  final String _kPrinterBranch = "printer_branch";
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
    if(preferenceData == null) return null;
    final data = json.decode(preferenceData);
    return UserInfo.fromJson(data);
  }

  Future<void> setLoginState(bool isLoggedIn) async{
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
    PrinterSetting? printerSetting,
    int? connectionType,
    int? paperSize,
    int? docketType,
  }) async {
    int branchId = printerSetting?.branchId ??
        (_preferences.getInt(_kPrinterBranch) ?? ZERO);
    int connection = printerSetting?.connectionType ?? connectionType!;
    int paper = printerSetting?.paperSize ?? paperSize!;
    int docket = printerSetting?.docketType ?? docketType!;
    await _preferences.setInt(_kPrinterBranch, branchId);
    await _preferences.setInt(_kPrinterConnectionType, connection);
    await _preferences.setInt(_kPrinterPaperSize, paper);
    await _preferences.setInt(_kDocketType, docket);
  }

  PrinterSetting printerSetting() {
    return PrinterSetting(
      branchId: _preferences.getInt(_kPrinterBranch) ?? ZERO,
      connectionType: _preferences.getInt(_kPrinterConnectionType) ??
          ConnectionType.BLUETOOTH,
      paperSize: _preferences.getInt(_kPrinterPaperSize) ?? RollId.mm80,
      docketType: _preferences.getInt(_kDocketType) ?? DocketType.customer,
    );
  }

  Future<void> clearPrinterSetting() async {
    await _preferences.remove(_kPrinterBranch);
    await _preferences.remove(_kPrinterPaperSize);
    await _preferences.remove(_kPrinterConnectionType);
    await _preferences.remove(_kDocketType);
  }

  Future<void> clearPreferences() async {
    await _preferences.remove(_kAccessToken);
    await _preferences.remove(_kRefreshToken);
    await _preferences.remove(_kUser);
    clearPrinterSetting();
  }
}
