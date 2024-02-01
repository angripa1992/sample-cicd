import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/notification/inapp/in_app_notification_handler.dart';
import 'package:klikit/notification/local_notification_service.dart';
import 'package:klikit/notification/notification_data_handler.dart';

import '../app/app_preferences.dart';
import '../app/constants.dart';
import '../app/session_manager.dart';
import '../env/env_manager.dart';
import '../env/environment_variables.dart';
import '../printer/printing_handler.dart';
import 'fcm_token_manager.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();

  final _fcmTokenManager = getIt.get<FcmTokenManager>();

  FcmService._internal();

  factory FcmService() {
    return _instance;
  }

  late final FirebaseMessaging messaging;

  Future initApp() async {
    messaging = FirebaseMessaging.instance;
  }

  Future<String> getFcmToken() async {
    final fcmToken = await messaging.getToken();
    debugPrint('fcm token => $fcmToken');
    return fcmToken ?? EMPTY;
  }

  void registerForegroundListener() {
    FirebaseMessaging.onMessage.listen(
      (message) {
        debugPrint('******Notification****** => ${message.data}');
        if (SessionManager().isLoggedIn()) {
          InAppNotificationHandler().handleNotification(
            NotificationDataHandler().getNotificationData(message.data),
          );
        }
      },
    );
  }

  void registerRefreshTokenListener() {
    messaging.onTokenRefresh.listen((fcmToken) {
      _fcmTokenManager.registerToken(fcmToken);
    }).onError((error) {});
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await registerLocalDB();
  await getIt.get<AppPreferences>().reload();
  await Firebase.initializeApp();

  final env = EnvironmentVariables(
    baseUrl: 'https://api.dev.shadowchef.co',
    cdnUrl: 'https://cdn.dev.shadowchef.co',
    consumerUrl: 'https://consumer.dev.shadowchef.co',
    segmentWriteKey: 'alQxTlFDYkl3TklCS2NiTll2UlNmTUhDTGs2dmxoRDQ=',
    slackUrl: 'https://hooks.slack.com/services/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',
    zohoAppKey: 'FlIXMZG3VUtYzlN8MUemAXC8RKrBKQds1Er4rWZQvv5GPkjAZYzxQ9OtSvBx7ai6',
    zohoAppAccessKey: 'Bb4BMRwMkXxb0xiK51IrfVDBXngyqVP07gWLRP54XhSACzcKVaDd47isUNyi6L456fRkg%2BQnMmmgACtXYjw61SCASk1cMZAB7xW4NBovvWUIRxvXqHdYyyxtI%2FrBT97g',
  );

  final environmentVariables = await EnvManager().fetchEnv(env);
  final printingHandler = getIt.get<PrintingHandler>();
  await initAppModule(environmentVariables);  if (SessionManager().notificationEnable()) {
    LocalNotificationService().showNotification(
      payload: message.data,
    );
    Future.delayed(const Duration(seconds: 2), () async {
      final order = await NotificationDataHandler().getOrderById(
          NotificationDataHandler().getNotificationData(message.data).orderId.toInt(),
      );
      if (order != null && order.status == OrderStatus.ACCEPTED) {
        printingHandler.printDocket(order: order, isAutoPrint: true);
      }
    });
  }
}
