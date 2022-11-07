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
  static String comment(int orderID) => '/v1/oni/order/$orderID/comment';
  static String menus(int brandID) => '/v2/menu/brand/$brandID/default/menus';
  static const String menuBrands = '/v1/brand';
}