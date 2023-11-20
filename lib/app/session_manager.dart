import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../core/route/routes.dart';
import '../core/route/routes_generator.dart';
import '../modules/common/business_information_provider.dart';
import '../modules/user/domain/entities/user.dart';

class SessionManager {
  late AppPreferences _appPreferences;
  static final _instance = SessionManager._internal();

  factory SessionManager() => _instance;

  SessionManager._internal() {
    _appPreferences = getIt.get();
    _init();
  }

  UserInfo? _user;

  void _init() {
    _user = _appPreferences.getUser();
    if (_user == null) {
      logout();
    }
  }

  Future<void> saveUser(UserInfo user) async {
    _appPreferences.saveUser(user);
    _user = _appPreferences.getUser();
  }

  Future<void> saveLastLoginEmail(String email) async {
    _appPreferences.saveLoginEmail(email);
  }

  Future<void> setLoginState({required bool isLoggedIn}) async {
    _appPreferences.setLoginState(isLoggedIn);
  }

  Future<void> setNotificationEnabled(bool enable) async {
    await _appPreferences.setNotificationEnable(enable);
  }

  Future<void> setSunmiDevice(bool isSunmiDevice) async {
    await _appPreferences.setSunmiDevice(isSunmiDevice);
  }

  Future<void> saveToken({
    required accessToken,
    required String refreshToken,
  }) async {
    _appPreferences.insertAccessToken(accessToken);
    _appPreferences.insertRefreshToken(refreshToken);
  }

  UserInfo? user() => _user;

  int id() => _user?.id ?? 0;

  String userName() => '${_user?.firstName} ${_user?.lastName}';

  bool menuV2EnabledForKlikitOrder() => (_user?.menuV2EnabledForKlikitOrder ?? false) && (_user?.menuVersionForKlikitOrder ?? MenuVersion.v1) == MenuVersion.v2;

  bool menuV2Enabled() => (_user?.menuV2Enabled ?? false) && (_user?.menuVersion ?? MenuVersion.v1) == MenuVersion.v2;

  int branchId() => _user?.branchIDs.first ?? 0;

  String branchName() => _user?.branchTitles.first ?? EMPTY;

  int businessID() => _user?.businessId ?? 0;

  String businessName() => _user?.businessName ?? EMPTY;

  List<int> brandIDs() => _user?.brandIDs ?? [];

  List<int> branchIDs() => _user?.branchIDs ?? [];

  List<String> brandTitles() => _user?.brandTitles ?? [];

  bool firstLogin() => _user?.firstLogin ?? false;

  String lastLoginEmail() => _appPreferences.loginEmail();

  String? accessToke() => _appPreferences.retrieveAccessToken();

  String? refreshToken() => _appPreferences.retrieveRefreshToken();

  bool isLoggedIn() => _appPreferences.isLoggedIn();

  bool notificationEnable() => _appPreferences.notificationEnable();

  bool isSunmiDevice() => _appPreferences.sunmiDevice();

  int country() => _user?.countryIds.first ?? 0;

  String userDisplayRole() => _user?.displayRoles.first ?? EMPTY;

  Future<void> logout() async {
    CartManager().clear();
    await setLoginState(isLoggedIn: false);
    getIt.get<BusinessInformationProvider>().clearData();
    final context = RoutesGenerator.navigatorKey.currentState?.context;
    if (context == null) return;
    _appPreferences.clearPreferences().then(
      (value) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
      },
    );
  }
}
