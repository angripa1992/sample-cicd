import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:klikit/app/constants.dart';
import 'package:klikit/notification/inapp/in_app_notification_handler.dart';
import 'package:klikit/notification/notification_handler.dart';
import 'package:klikit/resources/assets.dart';

import 'notification_data_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
  requestAlertPermission: false,
  requestBadgePermission: false,
  requestSoundPermission: false,
  onDidReceiveLocalNotification:
      (int id, String? title, String? body, String? payload) async {},
);

final InitializationSettings initializationSettings = InitializationSettings(
  iOS: initializationSettingsDarwin,
  android: initializationSettingsAndroid,
);

const AndroidNotificationChannel newOrderNotificationChanel =
    AndroidNotificationChannel(
  'high_importance_new_order',
  'High Importance New Order',
  importance: Importance.max,
  playSound: true,
);

const AndroidNotificationChannel cancelOrderNotificationChanel =
    AndroidNotificationChannel(
  'high_importance_cancel_order',
  'High Importance Cancel Order',
  importance: Importance.max,
  playSound: true,
);

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  NotificationHandler()
      .handleBackgroundNotification(notificationResponse.payload);
}

void notificationTap(NotificationResponse notificationResponse) {
  NotificationHandler()
      .handleBackgroundNotification(notificationResponse.payload);
}

class LocalNotificationService {
  static final LocalNotificationService _notificationService =
      LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _notificationService;
  }

  LocalNotificationService._internal();

  Future<Uint8List> getImageBytes(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  void showNotification({required Map<String, dynamic> payload}) async {
    final notificationData = NotificationDataHandler().getNotificationData(payload);
    final notificationType = int.parse(notificationData.type);
    flutterLocalNotificationsPlugin.show(
      notificationType,
      notificationData.title,
      notificationData.message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          notificationType == NotificationType.NEW
              ? newOrderNotificationChanel.id
              : cancelOrderNotificationChanel.id,
          notificationType == NotificationType.NEW
              ? newOrderNotificationChanel.name
              : cancelOrderNotificationChanel.name,
          importance: Importance.max,
          priority: Priority.max,
          color: Colors.white,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(
            notificationType == NotificationType.NEW
                ? AppSounds.newOrder
                : AppSounds.cancelOrder,
          ),
          icon: AppIcons.notificationIcon,
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(
            base64.encode(
              await getImageBytes(notificationData.providerUrl),
            ),
          ),
          additionalFlags: Int32List.fromList(<int>[4]),
          actions: [
            const AndroidNotificationAction(
              '1',
              'View Order',
              cancelNotification: true,
              showsUserInterface: true,
            ),
          ],
        ),
      ),
      payload: NotificationDataHandler().convertMapToString(payload),
    );
  }
}
