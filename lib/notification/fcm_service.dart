import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/notification/inapp/in_app_notification_handler.dart';
import 'package:klikit/notification/local_notification_service.dart';
import 'package:klikit/notification/notification_data_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  var localEnv = await getLocalEnv();
  await registerBackground(localEnv);

  if (SessionManager().notificationEnable()) {
    LocalNotificationService().showNotification(
      payload: message.data,
    );
    Future.delayed(const Duration(seconds: 2), () async {
      final order = await NotificationDataHandler().getOrderById(
          NotificationDataHandler().getNotificationData(message.data).orderId.toInt(),
      );
      if (order != null && order.status == OrderStatus.ACCEPTED) {
        var printingHandler = getIt.get<PrintingHandler>();
        printingHandler.printDocket(order: order, isAutoPrint: true);
      }
    });
  }
}

Future <EnvironmentVariables> getLocalEnv() async {
  String? envResp;

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  switch (packageInfo.packageName) {
    case AppConstant.devAppId:
      envResp = await rootBundle.loadString('assets/env/env-dev.json');
      break;

    case AppConstant.stagingAppId:
      envResp = await rootBundle.loadString('assets/env/env-staging.json');
      break;

    case AppConstant.prodAppId:
      envResp = await rootBundle.loadString('assets/env/env-prod.json');
      break;
    default:
      envResp = await rootBundle.loadString('assets/env/env-prod.json');
      break;
  }

  final data = await json.decode(envResp);

  EnvironmentVariables env = EnvironmentVariablesModel.fromJson(data).toEntity();
  final localEnv = await EnvManager().fetchEnv(env);
  return localEnv;
}