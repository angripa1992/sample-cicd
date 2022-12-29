import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/klikit.dart';
import 'package:klikit/environment_variables.dart';
import 'package:klikit/language/smart_asset_loader.dart';
import 'package:klikit/resources/assets.dart';

import 'app/di.dart';
import 'language/language_manager.dart';
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

  final supportedLocale = await getIt.get<LanguageManager>().getSupportedLocale();
  final startLocale = await getIt.get<LanguageManager>().getStartLocale();
  final supportedLocale = await getIt.get<LanguageManager>().getSupportedLocale();
  final startLocale = await getIt.get<LanguageManager>().getStartLocale();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
        (_) =>
        runApp(
          EasyLocalization(
            path: AppAssets.translations,
            supportedLocales: supportedLocale,
            fallbackLocale: const Locale('en', 'US'),
            startLocale: startLocale,
            assetLoader: SmartAssetLoader(),
            child: const Klikit(),
          ),
        ),
    (_) => runApp(
      EasyLocalization(
        path: AppAssets.translations,
        supportedLocales: supportedLocale,
        fallbackLocale: const Locale('en', 'US'),
        startLocale: startLocale,
        assetLoader: SmartAssetLoader(),
        child: const Klikit(),
      ),
    ),
  );
}
