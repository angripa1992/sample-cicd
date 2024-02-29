import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:klikit/app/di.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app/constants.dart';
import '../env/env_manager.dart';
import '../env/environment_variables.dart';
import 'fcm_token_manager.dart';

class FcmService {
  static final FcmService _instance = FcmService._internal();

  final _fcmTokenManager = getIt.get<FcmTokenManager>();

  FcmService._internal();

  factory FcmService() {
    return _instance;
  }

  // late final FirebaseMessaging messaging;
  //
  // Future initApp() async {
  //   messaging = FirebaseMessaging.instance;
  // }

  // Future<String> getFcmToken() async {
  //   final fcmToken = await messaging.getToken();
  //   debugPrint('fcm token => $fcmToken');
  //   return fcmToken ?? EMPTY;
  // }

  void registerForegroundListener() {
    // FirebaseMessaging.onMessage.listen(
    //   (message) {
    //     debugPrint('******Notification****** => ${message.data}');
    //     if (SessionManager().isLoggedIn()) {
    //       InAppNotificationHandler().handleNotification(
    //         NotificationDataHandler().getNotificationData(message.data),
    //       );
    //     }
    //   },
    // );
  }

  void registerRefreshTokenListener() {
    // messaging.onTokenRefresh.listen((fcmToken) {
    //   _fcmTokenManager.registerToken(fcmToken);
    // }).onError((error) {});
  }
}

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   try {
//     var localEnv = await getLocalEnv();
//     await registerBackground(localEnv);
//     if (SessionManager().notificationEnable()) {
//       await LocalNotificationService().showNotification(payload: message.data);
//     }
//     Future.delayed(const Duration(seconds: 2), () async {
//       final order = await NotificationDataHandler().getOrderById(
//         NotificationDataHandler().getNotificationData(message.data).orderId.toInt(),
//       );
//       if (order != null && order.status == OrderStatus.ACCEPTED) {
//         await getIt.get<PrinterManager>().doAutoDocketPrinting(order: order, isFromBackground: true);
//       }
//     });
//   } catch (e) {
//     //ignore
//   }
// }

Future<EnvironmentVariables> getLocalEnv() async {
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

  EnvironmentVariables env =
      EnvironmentVariablesModel.fromJson(data).toEntity();
  final localEnv = await EnvManager().fetchEnv(env);
  return localEnv;
}
