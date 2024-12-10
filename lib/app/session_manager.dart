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
    _appPreferences = getIt.get<AppPreferences>();
    _init();
  }

  UserInfo? _user;

  void _init() {
    _user = _appPreferences.getUser();
    if (_user == null) {
      logout();
    }
  }

  Future<void> saveLastLoginEmail(String email) async => _appPreferences.saveLoginEmail(email);

  Future<void> setLoginState({required bool isLoggedIn}) async => _appPreferences.setLoginState(isLoggedIn);

  Future<void> setNotificationEnabled(bool enable) async => await _appPreferences.setNotificationEnable(enable);

  Future<void> saveUser(UserInfo user) async {
    _appPreferences.saveUser(user);
    _user = _appPreferences.getUser();
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

  bool menuV2EnabledForKlikitOrder() => true;

  bool menuV2Enabled() => true;

  // bool menuV2EnabledForKlikitOrder() => (_user?.menuV2EnabledForKlikitOrder ?? false) && (_user?.menuVersionForKlikitOrder ?? MenuVersion.v1) == MenuVersion.v2;
  //
  // bool menuV2Enabled() => (_user?.menuV2Enabled ?? false) && (_user?.menuVersion ?? MenuVersion.v1) == MenuVersion.v2;


  int branchId() {
    if (_user != null && _user!.branchIDs.isNotEmpty) {
      return _user!.branchIDs.first;
    }
    return ZERO;
  }

  String branchName() {
    if (_user != null && _user!.branchTitles.isNotEmpty) {
      return _user!.branchTitles.first;
    }
    return EMPTY;
  }

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

  int country() => _user?.countryIds.first ?? 0;

  String countryCode() => _user?.countryCodes.first ?? "";

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
