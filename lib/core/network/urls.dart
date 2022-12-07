import 'package:klikit/app/constants.dart';

class Urls{
  static const String refreshToken = '/v1/token/refresh';
  static const String login = '/v1/login';
  static const String logout = '/v1/logout';
  static const String userUpdate = '/v1/user';
  static const String forgetPassword = '/v1/password/forgot';
  static const String changePassword = '/v1/password/change';
  static const String status = '/v1/oni/statuses';
  static const String order = '/v1/oni/order';
  static const String brand = '/v1/brand';
  static const String provider = '/v1/provider';
  static const String printerSettings = '/v1/printer/settings';
  static const String busy = '/v1/brand-provider/busy';
  static const String updateStatus = '/v1/oni/order/status';
  static const String tokenRegistration = '/v1/notify-token';
  static String comment(int orderID) => '/v1/oni/order/$orderID/comment';
  static String menus(int branchId) => '/v2/menu/branch/$branchId/menus';
  static const String menuBrands = '/v1/brand';
  static const String sources = '/v1/oni/order-sources';
  static String updateItem(int id) => '/v2/menu/item/$id/stock/status';
  static String updateMenu(int id,int type) => '/v1/menu/${type == MenuType.SECTION ? 'section' : 'sub_section'}/$id/enabled';
  static const String modifiersGroup = '/v1/menu/groups/modifiers';
  static String modifiersDisabled(int id,int type) => '/v1/menu/${type == ModifierType.MODIFIER ? 'modifiers' : 'groups'}/$id/verify/disabled';
  static String modifiersEnabled(int id,int type) => '/v1/menu/${type == ModifierType.MODIFIER ? 'modifiers' : 'groups'}/$id/enabled';
}