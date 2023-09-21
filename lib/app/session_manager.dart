import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../core/route/routes.dart';
import '../core/route/routes_generator.dart';
import '../modules/orders/provider/order_information_provider.dart';
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

  bool menuV2EnabledForKlikitOrder() => _user?.menuV2EnabledForKlikitOrder ?? false;

  int branchId() => _user?.branchIDs.first ?? 0;

  String branchName() => _user?.branchTitles.first ?? EMPTY;

  int businessID() => _user?.businessId ?? 0;

  String businessName() => _user?.businessName ?? EMPTY;

  List<int> brandIDs() => _user?.brandIDs ?? [];

  List<String> brandTitles() => _user?.brandTitles ?? [];

  bool firstLogin() => _user?.firstLogin ?? false;

  String lastLoginEmail() => _appPreferences.loginEmail();

  String? accessToke() => _appPreferences.retrieveAccessToken();

  String? refreshToken() => _appPreferences.retrieveRefreshToken();

  bool isLoggedIn() => _appPreferences.isLoggedIn();

  bool notificationEnable() => _appPreferences.notificationEnable();

  bool isSunmiDevice() => _appPreferences.sunmiDevice();

  bool isMenuV2() => _user?.menuV2Enabled ?? false;

  int country() => _user?.countryIds.first ?? 0;

  String userDisplayRole() => _user?.displayRoles.first ?? EMPTY;

  Future<void> logout() async {
    CartManager().clear();
    await setLoginState(isLoggedIn: false);
    getIt.get<OrderInformationProvider>().clearData();
    _appPreferences.clearPreferences().then(
      (value) {
        Navigator.pushNamedAndRemoveUntil(
          RoutesGenerator.navigatorKey.currentState!.context,
          Routes.login,
          (route) => false,
        );
      },
    );
  }
}
