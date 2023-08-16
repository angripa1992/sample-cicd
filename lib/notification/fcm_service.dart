import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/notification/inapp/in_app_notification_handler.dart';
import 'package:klikit/notification/local_notification_service.dart';
import 'package:klikit/notification/notification_data_handler.dart';

import '../app/app_preferences.dart';
import '../app/session_manager.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();

  //final _fcmTokenManager = getIt.get<FcmTokenManager>();

  FcmService._internal();

  factory FcmService() {
    return _instance;
  }

  late final FirebaseMessaging messaging;

  Future initApp() async {
    messaging = FirebaseMessaging.instance;
  }

  Future<String?> getFcmToken() async {
    final fcmToken = await messaging.getToken();
    debugPrint('fcm token => $fcmToken');
    return fcmToken;
  }

  void registerForegroundListener() {
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (SessionManager().isLoggedIn()) {
          InAppNotificationHandler().handleNotification(
            NotificationDataHandler().getNotificationData(
              message.data,
            ),
          );
        }
      },
    );
  }

  void registerRefreshTokenListener() {
    messaging.onTokenRefresh.listen((fcmToken) {
      //_fcmTokenManager.registerToken(fcmToken);
    }).onError((error) {});
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await registerLocalDB();
  await getIt.get<AppPreferences>().reload();
  if (SessionManager().notificationEnable()) {
    LocalNotificationService().showNotification(
      payload: message.data,
    );
  }
}
