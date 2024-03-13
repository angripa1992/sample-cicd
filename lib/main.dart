import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/klikit.dart';
import 'package:klikit/core/network/slack_logger.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:klikit/language/smart_asset_loader.dart';
import 'package:klikit/resources/assets.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/io.dart';
import 'package:window_manager/window_manager.dart';

import 'app/di.dart';
import 'core/utils/permission_handler.dart';
import 'env/env_manager.dart';
import 'language/language_manager.dart';
import 'modules/widgets/loader.dart';
import 'notification/local_notification_service.dart';

void mainCommon(EnvironmentVariables env) async {


  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {

    WindowManager.instance.setMaximumSize(const Size(1080, 820));
    WindowManager.instance.setMinimumSize(const Size(980, 720));
  }
  Wakelock.enable();
  // await Firebase.initializeApp();
  final environmentVariables = await EnvManager().fetchEnv(env);
  // CrashlyticsConfiguration().initialize();
  await EasyLocalization.ensureInitialized();
  await initAppModule(environmentVariables);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: notificationTap,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  // await FcmService().initApp();
  // FcmService().registerForegroundListener();
  // FcmService().registerRefreshTokenListener();
  // await FcmService().getFcmToken();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SlackLoggerResolver().initLogger();

  final supportedLocale = await getIt.get<LanguageManager>().getSupportedLocale();
  final startLocale = await getIt.get<LanguageManager>().getStartLocale();

  configLoading();

  await PermissionHandler().requestPermissions();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
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
void onStart() {
  final channel = IOWebSocketChannel.connect(
      'wss://socket.dev.shadowchef.co/socket.io/?token=YOUR_TOKEN_HERE&EIO=3&transport=websocket');

  Timer.periodic(Duration(seconds: 5), (timer) {
    // Periodically send a message to keep the connection alive
    channel.sink.add('{"type": "ping"}');
  });

  channel.stream.listen((data) {
    // Handle the received data
    final decodedData = json.decode(data.toString());
    print('Received data: $decodedData');
  });
}