import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/route/routes_generator.dart';
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
      navigateToOrderScreen(notificationData,
          notificationType: NotificationType.BACKGROUD);
    } else {
      _navigateToLoginScreen(notificationData);
    }
  }

  void navigateToOrderScreen(NotificationData notificationData, {bool isNotification = true, required int notificationType}) {
    Navigator.of(RoutesGenerator.navigatorKey.currentState!.context)
        .pushNamedAndRemoveUntil(
      Routes.base,
      (Route<dynamic> route) => false,
      arguments: {
        ArgumentKey.kIS_NOTIFICATION: isNotification,
        ArgumentKey.kNOTIFICATION_DATA: notificationData,
        ArgumentKey.kNOTIFICATION_TYPE: notificationType,
      },
    );
  }

  void _navigateToLoginScreen(NotificationData notificationData) {
    Navigator.of(RoutesGenerator.navigatorKey.currentState!.context)
        .pushNamedAndRemoveUntil(
      Routes.login,
      (Route<dynamic> route) => false,
      arguments: {
        ArgumentKey.kNOTIFICATION_DATA: notificationData,
      },
    );
  }
}
