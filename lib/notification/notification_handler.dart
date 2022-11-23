import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/notification/notification_data.dart';

import '../../app/constants.dart';
import '../../app/di.dart';
import '../../core/route/routes.dart';
import 'inapp/in_app_notification_handler.dart';
import 'notification_data_handler.dart';

class NotificationHandler {
  static final _instance = NotificationHandler._internal();
  final _appPreference = getIt.get<AppPreferences>();

  factory NotificationHandler() => _instance;

  NotificationHandler._internal();

  void handleBackgroundNotification(String? payload) {
    InAppNotificationHandler().dismissInAppNotification();
    if (payload == null) return;
    final notificationData = NotificationDataHandler().getNotificationData(
        NotificationDataHandler().convertStringToMap(payload));
    if (_appPreference.isLoggedIn()) {
      navigateToOrderScreen(notificationData);
    } else {
      _navigateToLoginScreen(notificationData);
    }
  }

  void navigateToOrderScreen(NotificationData notificationData) {
    Navigator.of(RoutesGenerator.navigatorKey.currentState!.context)
        .pushNamedAndRemoveUntil(
      Routes.base,
      (Route<dynamic> route) => false,
      arguments: {
        'is_notification': true,
        'navigation_data': notificationData.type.toInt() == NotificationType.NEW
            ? NavigationData(
                index: BottomNavItem.ORDER,
                subTabIndex: OrderTab.NEW,
                data: null,
              )
            : NavigationData(
                index: BottomNavItem.ORDER,
                subTabIndex: OrderTab.History,
                data: {
                  HistoryNavData.HISTORY_NAV_DATA: HistoryNavData.today(),
                },
              ),
      },
    );
  }

  void _navigateToLoginScreen(NotificationData notificationData) {
    Navigator.of(RoutesGenerator.navigatorKey.currentState!.context)
        .pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false,
            arguments: {'notification_data': notificationData});
  }
}
