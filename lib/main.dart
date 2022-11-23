import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/klikit.dart';
import 'package:klikit/environment_variables.dart';
import 'package:klikit/resources/assets.dart';

import 'app/di.dart';
import 'notification/fcm_service.dart';
import 'notification/local_notification_service.dart';

void mainCommon(EnvironmentVariables environmentVariables) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule(environmentVariables);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: notificationTap,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  await FcmService().initApp();
  FcmService().registerForegroundListener();
  FcmService().registerRefreshTokenListener();
  await FcmService().getFcmToken();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
    (_) => runApp(
      EasyLocalization(
        path: AppAssets.translations,
        supportedLocales: const [Locale('en', 'US')],
        fallbackLocale: const Locale('en', 'US'),
        child: const Klikit(),
      ),
    ),
  );
}
