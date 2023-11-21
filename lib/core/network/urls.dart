import 'package:klikit/app/constants.dart';

class Urls {
  static const String refreshToken = '/v1/token/refresh';
  static const String login = '/v1/login';
  static const String logout = '/v1/logout';
  static const String userUpdate = '/v1/user';
  static const String forgetPassword = '/v1/password/forgot';
  static const String changePassword = '/v1/password/change';
  static const String userSettings = '/v1/user/settings';
  static const String status = '/v1/oni/statuses';
  static const String order = '/v1/oni/order';
  static const String omsOrder = '/v1/oni/oms/raw-order';
  static const String brand = '/v1/brand';

  static String branch(int id) => '/v1/branch/$id';

  static String updateWebShopOrder(int id) => '/v1/oni/oms/order/$id';
  static const String provider = '/v1/provider';
  static const String printerSettings = '/v1/printer/settings';
  static const String pauseStore = '/v1/brand-provider/busy';
  static const String updateStatus = '/v1/oni/order/status';
  static const String updatePaymentInfo = '/v1/oni/manualorder/payment';
  static const String tokenRegistration = '/v1/notify-token';
  // static const String webShopCalculateBill = 'v1/oms/order/calculate-bill';
  static const String webShopCalculateBill = '/v1/oms/calculate/bill';
  static const String calculateBill = '/v1/menu/manual-order/calculate-bill';
  static const String calculateBillV2 = '/v1/menu-v2/manual-order/calculate-bill';
  static const String calculateGrabOrderBill = '/v1/oni/grabfoodorder/calculate-bill';
  static const String updateGrabOrder = '/v1/oni/grabfoodorder';
  static const String manualOrder = '/v1/oni/manualorder';
  static const String promos = '/v1/promoit/promo/common/search';
  static const String cancellationReasons = '/v1/oni/cancel-order-reasons';
  static const String zReportSummary = '/v2/analyseit/z-report/summary';

  static String findRider(int id) => '/v1/oni/order/fulfillment/dispatch/$id';

  static String updatePrepTime(int id) => '/v1/oni/order/$id/preparation-time';

  static String cancelRider(int id) => '/v1/oni/order/$id/cancel-fulfillment';

  static String comment(int orderID) => '/v1/oni/order/$orderID/comment';

  static String menuV1(int branchId) => '/v2/menu/branch/$branchId/menus';
  static String menuV2 = '/v1/menu-v2/nma/store/menus';
  static const String menuBrands = '/v1/brand';

  static String menuBrand(int brandId) => '/v1/brand/$brandId';
  static const String sources = '/v1/oni/order-sources';
  static const String paymentMethod = '/v1/oni/payment-channels';
  static const String paymentStatus = '/v1/oni/payment-statuses';

  static String updateV1ItemSnooze(int id) => '/v2/menu/item/$id/stock/status';

  static String updateV2temSnooze(int id) => '/v1/menu-v2/items/$id/snooze';

  static String updateMenu(int id, int type) => '/v1/menu/${type == MenuType.SECTION ? 'section' : 'sub_section'}/$id/enabled';

  static String updateV2Menu(String type) => '/v1/menu-v2/$type/enable';
  static const String v1ModifiersGroup = '/v1/menu/groups/modifiers';
  static const String v2ModifiersGroup = '/v1/menu-v2/nma/store/modifier-groups';
  static const String itmModifiers = '/v1/menu/item-modifiers';
  static const String itmModifiersV2 = '/v1/menu-v2/nma/store/items/modifier-groups';

  static String checkAffect(int id, int type) => '/v1/menu/${type == ModifierType.MODIFIER ? 'modifiers' : 'groups'}/$id/verify/disabled';
  static String checkAffectV2 = '/v1/menu-v2/nma/store/groups/verify/disabled';

  static String updateModifierEnabled(int id, int type) => '/v1/menu/${type == ModifierType.MODIFIER ? 'modifiers' : 'groups'}/$id/enabled';

  static String updateModifierEnabledV2(int type) => '/v1/menu-v2/modifier-groups${type == ModifierType.MODIFIER ? '/modifiers' : ''}/enable';
}
