import 'dart:convert';

import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/notification/notification_data.dart';

import '../app/constants.dart';

class NotificationDataHandler {
  static final NotificationDataHandler _instance =
      NotificationDataHandler._internal();

  factory NotificationDataHandler() {
    return _instance;
  }

  NotificationDataHandler._internal();

  String convertMapToString(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  Map<String, dynamic> convertStringToMap(String data) {
    return jsonDecode(data);
  }

  NotificationData getNotificationData(Map<String, dynamic> data) {
    return NotificationData.fromJson(data);
  }

  Future<Order?> getOrderById(int id) async {
    final repository = getIt.get<OrderRepository>();
    final response = await repository.fetchOrderById(id);
    return response;
  }

  NavigationData getNavData(NotificationData notificationData) {
    if (notificationData.type.toInt() == NotificationType.NEW) {
      return NavigationData(
          index: BottomNavItem.ORDER, subTabIndex: OrderTab.NEW, data: null);
    } else {
      return NavigationData(
        index: BottomNavItem.ORDER,
        subTabIndex: OrderTab.History,
        data: {
          HistoryNavData.HISTORY_NAV_DATA: HistoryNavData.today(),
        },
      );
    }
  }
}
