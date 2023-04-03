import 'package:flutter/material.dart';

class AppConstant {
  static const String signUpUrl =
      "https://www.klikit.io/contact?__hstc=140989165.3e68213999864dc1ab0072336446cdf8.1660889383375.1661919284520.1661927239769.12&__hssc=140989165.1.1661927239769&__hsfp=2812450310";
  static const String roleBranchManger = "branch_manager";
  static const String roleAdmin = "admin";
  static const String roleBrandManager = "brand_manager";
  static const String roleBusinessOwner = "business_owner";
  static const String whatappSupportNumber = "+639762884283";
  static const String supportMail = "help@klikit.io";
  static const int refreshTime = 30;
  static const int busyTimeInMin = 60;
}

class HistoryNavData {
  static const String HISTORY_NAV_DATA = 'history_nav_data';

  static DateTimeRange today() => DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      );

  static DateTimeRange yesterday() => DateTimeRange(
        start: DateTime.now().subtract(
          const Duration(days: 1),
        ),
        end: DateTime.now().subtract(
          const Duration(days: 1),
        ),
      );
}

class ObserverTag {
  static const TOTAL_ORDER = "total_order";
  static const NEW_ORDER = "new_order";
  static const ONGOING_ORDER = "ongoing_order";
  static const SCHEDULE_ORDER = "schedule_order";
  static const ORDER_HISTORY = "order_history";
  static const ORDER_SCREEN = "order_screen";
}

class BottomNavItem {
  static const int HOME = 0;
  static const int ORDER = 1;
  static const int ADD_ORDER = 2;
  static const int MENU = 3;
  static const int ACCOUNT = 4;
}

class OrderTab {
  static const int NEW = 0;
  static const int ONGOING = 1;
  static const int SCHEDULE = 2;
  static const int History = 3;
}

class OrderType {
  static const int PICKUP = 1;
  static const int DELIVERY = 2;
  static const int DINE_IN = 3;
}

class ProviderID {
  static const int KLIKIT = 1;
  static const int GRAB_FOOD = 6;
  static const int FOOD_PANDA = 7;
  static const int SHOPEE = 11;
}

class OrderStatus {
  static const PLACED = 1;
  static const ACCEPTED = 2;
  static const CANCELLED = 3;
  static const READY = 4;
  static const DELIVERED = 5;
  static const SCHEDULED = 6;
  static const DRIVER_ASSIGNED = 7;
  static const DRIVER_ARRIVED = 8;
  static const PICKED_UP = 9;
}

class MenuTabIndex {
  static const MENU = 1;
  static const MODIFIER = 2;
}

class MenuType {
  static const SECTION = 1;
  static const SUB_SECTION = 2;
  static const ITEM = 3;
}

class ModifierType {
  static const GROUP = 1;
  static const MODIFIER = 2;
}

class NotificationOrderType {
  static const NEW = 1;
  static const CANCEL = 2;
}

class NotificationType {
  static const BACKGROUD = 1;
  static const IN_APP = 2;
  static const TERMINATED = 3;
}

class ConnectionType {
  static const BLUETOOTH = 1;
  static const USB = 2;
}

class RollId {
  static const mm58 = 1;
  static const mm80 = 2;
}

class DocketType {
  static const kitchen = 1;
  static const customer = 2;
}

class DurationType {
  static const day_1 = 24;
  static const day_3 = 72;
  static const day_7 = 168;
  static const defaultTime = 0;
}

class PaymentStatusId {
  static const paid = 1;
  static const failed = 2;
  static const pending = 3;
  static const refunded = 4;
}

class RuleType{
  static const exact= 'exact';
  static const range= 'range';
}

class ArgumentKey {
  static const String kIS_NOTIFICATION = 'is_notification';
  static const String kNOTIFICATION_DATA = 'notification_data';
  static const String kNOTIFICATION_TYPE = 'notification_type';
  static const String kPROVIDER_ID = 'provider_id';
  static const String kGROUP = 'group';
  static const String kBRAND_ID = 'brand_id';
  static const String kSECTIONS = 'sections';
  static const String kENABLED = 'enabled';
}
