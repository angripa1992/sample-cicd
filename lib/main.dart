import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/klikit.dart';
import 'package:klikit/core/network/slack_logger.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/language/smart_asset_loader.dart';
import 'package:klikit/resources/assets.dart';
import 'package:wakelock/wakelock.dart';

import 'app/crashlytics_config.dart';
import 'app/di.dart';
import 'env/env_manager.dart';
import 'language/language_manager.dart';
import 'modules/widgets/loader.dart';
import 'notification/fcm_service.dart';
import 'notification/local_notification_service.dart';

void mainCommon(EnvironmentVariables env) async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await Firebase.initializeApp();
  final environmentVariables = await EnvManager().fetchEnv(env);
  CrashlyticsConfiguration().initialize();
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

  SlackLoggerResolver().initLogger();

  final supportedLocale = await getIt.get<LanguageManager>().getSupportedLocale();
  final startLocale = await getIt.get<LanguageManager>().getStartLocale();

  configLoading();

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
  );
}
