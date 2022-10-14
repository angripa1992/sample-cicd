class AppConstant {
  static const String signUpUrl = "https://www.klikit.io/contact?__hstc=140989165.3e68213999864dc1ab0072336446cdf8.1660889383375.1661919284520.1661927239769.12&__hssc=140989165.1.1661927239769&__hsfp=2812450310";
  static const String roleBranchManger = "branch_manager";
  static const String roleAdmin = "admin";
  static const String roleBrandManager = "brand_manager";
  static const String roleBusinessOwner = "business_owner";
  static const String supportNumber = "+63 203 4090 2112";
  static const String supportMail = "example@exampl.co";
  static const int refreshTime = 30;
  static const int busyTimeInMin = 60;
  static const int TYPE_PICKUP = 1;
  static const int TYPE_DELIVERY = 2;
}

class ObserverTag{
  static const TOTAL_ORDER = "total_order";
  static const NEW_ORDER = "new_order";
  static const ONGOING_ORDER = "ongoing_order";
  static const ORDER_HISTORY = "order_history";
  static const ORDER_SCREEN = "order_screen";
}

class BottomNavItem{
  static const int HOME = 0;
  static const int ORDER = 1;
  static const int STOCK = 2;
  static const int ACCOUNT = 3;
}

class OrderTab{
  static const int NEW = 0;
  static const int ONGOING = 1;
  static const int History = 2;
}
