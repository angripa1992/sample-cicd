/*

user mobile - (trait -> phone)
user email - (trait -> email)
user type -  (trait -> title)

app version -  (context -> app -> version)
device OS -  (context -> device -> type)
device OS version -  (context -> device -> version)
device model -  (context -> device -> model)

location(city) - (context -> location -> city)
location(country) - (context -> location -> country)
location(lat) - (context -> location -> latitude)
location(lon) - (context -> location -> longitude)

*/

import 'package:klikit/core/provider/location_provider.dart';
import 'package:klikit/segments/segments_data_model.dart';

import '../app/app_preferences.dart';
import '../core/provider/device_information_provider.dart';

class SegmentDataProvider {
  final AppPreferences _appPreferences;
  final DeviceInfoProvider _deviceInfoProvider;
  final LocationProvider _locationProvider;
  SegmentTraits? _traits;
  SegmentDevice? _device;
  SegmentApp? _app;

  SegmentDataProvider(
      this._appPreferences, this._deviceInfoProvider, this._locationProvider);

  SegmentTraits _getTraits() {
    if (_traits == null) {
      final userInfo = _appPreferences.getUser().userInfo;
      _traits = SegmentTraits(
        email: userInfo.email,
        phone: userInfo.phone,
        title: userInfo.displayRoles[0],
      );
    }
    return _traits!;
  }

  Future<SegmentDevice> _getDevice() async {
    _device ??= SegmentDevice(
      type: _deviceInfoProvider.platformName(),
      version: await _deviceInfoProvider.getOsVersion(),
      model: await _deviceInfoProvider.getDeviceModel(),
    );
    return _device!;
  }

  Future<SegmentApp> _getApp() async {
    _app ??= SegmentApp(
      version: await _deviceInfoProvider.versionName(),
    );
    return _app!;
  }

  Future<SegmentLocation?> _getLocation() async {
    final position = await _locationProvider.currentPosition();
    if (position == null) return _geCountryId();
    final placeMark = await _locationProvider.placeMarkFromCoordinates(lat: position.latitude, lan: position.longitude);
    if (placeMark == null) return _geCountryId();
    return SegmentLocation(
      city: placeMark.locality,
      country: placeMark.country,
      latitude: position.latitude.toString(),
      longitude: position.longitude.toString(),
    );
  }

  SegmentLocation _geCountryId() {
    final countryCode = _appPreferences.getUser().userInfo.countryCodes.first;
    return SegmentLocation(
      country: countryCode,
    );
  }

  String _timestamp() => DateTime.now().toString();

  Future<SegmentData> identifyData({required String event}) async {
    return SegmentData(
      userId: _appPreferences.getUser().userInfo.id.toString(),
      event: event,
      timestamp: _timestamp(),
      traits: _getTraits(),
      context: SegmentContext(
        app: await _getApp(),
        device: await _getDevice(),
        location: await _getLocation(),
      ),
    );
  }

  Future<SegmentData> trackData({
    required String event,
    Map<String, dynamic>? properties,
  }) async {
    return SegmentData(
      userId: _appPreferences.getUser().userInfo.id.toString(),
      event: event,
      properties: properties,
      timestamp: _timestamp(),
      context: SegmentContext(
        app: await _getApp(),
        device: await _getDevice(),
        traits: _getTraits(),
        location: await _getLocation(),
      ),
    );
  }

  Future<SegmentData> screenData({
    required String event,
    required String name,
    Map<String, dynamic>? properties,
  }) async {
    return SegmentData(
      userId: _appPreferences.getUser().userInfo.id.toString(),
      event: event,
      name: name,
      properties: properties,
      timestamp: _timestamp(),
      context: SegmentContext(
        app: await _getApp(),
        device: await _getDevice(),
        traits: _getTraits(),
        location: await _getLocation(),
      ),
    );
  }
}

class SegmentEvents {
  static const String USER_LOGGED_IN = 'user_logged_in_NMA_core';
  static const String USER_LOGGED_OUT = 'user_logged_out_NMA_core';
  static const String BUSY_MODE = 'busy_mode_NMA_home';
  static const String ORDER_TAB = 'order_tab_NMA';
  static const String MENU_TAB = 'menu_tab_NMA';
  static const String HOME_TAB = 'home_tab_NMA';
  static const String ACCOUNT_TAB = 'account_tab_NMA';
  static const String SEE_DETAILS = 'see_details_NMA_order';
  static const String ACCEPT_ORDER = 'accept_NMA_order';
  static const String CANCEL_ORDER = 'cancel_NMA_order';
  static const String PRINT_ORDER = 'print_NMA_order';
  static const String READY_ORDER = 'ready_NMA_order';
  static const String DELIVER_ORDER = 'deliver_NMA_order';
  static const String PICKUP_ORDER = 'pickup_NMA_order';
  static const String MENU_SCREEN = 'menu_screen_NMA';
  static const String MODIFIER_SCREEN = 'modifier_screen_NMA';
  static const String MENUE_CLICK = 'menu_click_NMA_menu';
  static const String MENUE_TOGGLE = 'menu_toggle_NMA_menu';
  static const String CATEGORY_TOGGLE = 'category_toggle_NMA_menu';
  static const String ITEM_TOGGLE = 'item_toggle_NMA_menu';
  static const String MODIFIER_CLICK = 'modifier_click_NMA_menu';
}
