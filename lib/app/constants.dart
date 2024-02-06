import 'package:flutter/material.dart';

class AppConstant {
  static const String signUpUrl =
      "https://www.klikit.io/contact?__hstc=140989165.3e68213999864dc1ab0072336446cdf8.1660889383375.1661919284520.1661927239769.12&__hssc=140989165.1.1661927239769&__hsfp=2812450310";
  static const String whatsappSupportNumber = "+6281936119055";
  static const String supportMail = "help@klikit.io";
  static const int refreshTime = 30;
  static const int busyTimeInMin = 60;
}

class UserRole {
  static const String branchManger = "branch_manager";
  static const String admin = "admin";
  static const String brandManager = "brand_manager";
  static const String businessOwner = "business_owner";
  static const String staff = "staff";
  static const String cashier = "cashier";
}

class UserPermission {
  static const String cancelOrder = "cancel.order";
  static const String oosMenu = "oos.menu";
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
  static const ALL_ORDER = "all_order";
  static const ONGOING_ORDER = "ongoing_order";
  static const SCHEDULE_ORDER = "schedule_order";
  static const OTHERS_ORDER = "others_order";
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
  static const int ALL = 2;
  static const int SCHEDULE = 3;
  static const int History = 4;
  static const int OTHERS = 5;
}

class OrderType {
  static const int PICKUP = 1;
  static const int DELIVERY = 2;
  static const int DINE_IN = 3;
}

class PickupType {
  static const int DEFAULT = 1;
  static const int DRIVE_THRU = 2;
}

class OrderSource {
  static const int IN_STORE = 9;
}

class PaymentMethodID {
  static const int CASH = 2;
  static const int QR = 17;
}

class PaymentChannelID {
  static const int CASH = 31;
  static const int CREATE_QRIS = 37;
}

class ProviderID {
  static const int KLIKIT = 1;
  static const int UBER_EATS = 2;
  static const int DELIVEROO = 3;
  static const int DOOR_DASH = 5;
  static const int GRAB_FOOD = 6;
  static const int FOOD_PANDA = 7;
  static const int GO_FOOD = 9;
  static const int SHOPEE = 11;
  static const int PICKAROO = 13;
  static const int WOLT = 14;
  static const int SQUARE = 15;
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

class TabIndex {
  static const MENU = 1;
  static const MODIFIER = 2;
  static const DOCKET = 3;
  static const STICKER = 4;
}

class MenuType {
  static const SECTION = 1;
  static const CATEGORY = 2;
  static const ITEM = 3;
}

class ModifierType {
  static const GROUP = 1;
  static const MODIFIER = 2;
}

class NotificationOrderType {
  static const NEW = 1;
  static const CANCEL = 2;
  static const SCHEUDLE = 3;
}

class NotificationType {
  static const BACKGROUD = 1;
  static const IN_APP = 2;
  static const TERMINATED = 3;
}

class CType {
  static const DISABLED = 0;
  static const BLE = 1;
  static const USB = 2;
  static const WIFI = 3;
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

class RuleType {
  static const exact = 'exact';
  static const range = 'range';
}

class DiscountType {
  static const none = 0;
  static const flat = 1;
  static const percentage = 2;
}

class Device {
  static const android = 1;
  static const sunmi = 2;
  static const imin = 3;
}

class PrinterSelectIndex {
  static const docket = 0;
  static const sticker = 1;
}

class MenuVersion {
  static const v1 = 1;
  static const v2 = 2;
}

class FulfillmentStatusId {
  static const ALLOCATING_RIDER = 1; //or 2
  static const ALLOCATING_RIDER_TWO = 2;
  static const FOUND_RIDER = 3;
  static const PICKING_UP = 4;
  static const IN_DELIVERY = 5;
  static const COMPLETED = 6;
  static const RETURNED = 7;
  static const CANCELED = 8; // or 9
  static const CANCELED_TWO = 9;
  static const IN_RETURN = 10;
  static const DISPATCH_FAILED = 11;
}

class ArgumentKey {
  static const String kIS_NOTIFICATION = 'is_notification';
  static const String kIS_NAVIGATE = 'is_navigate';
  static const String kNOTIFICATION_DATA = 'notification_data';
  static const String kNAVIGATE_DATA = 'navigate_data';
  static const String kNOTIFICATION_TYPE = 'notification_type';
  static const String kPROVIDER_ID = 'provider_id';
  static const String kGROUP = 'group';
  static const String kBRAND_ID = 'brand_id';
  static const String kBRANCH_ID = 'branch_id';
  static const String kMENU_CATEGORY = 'menu_category';
  static const String kENABLED = 'enabled';
  static const String kOPEN_CART = 'clear_cart';
  static const String kUPDATE_CART = 'update_order';
}
