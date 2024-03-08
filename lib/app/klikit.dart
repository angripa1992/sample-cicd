import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/utils/socket_handler.dart';
import 'package:klikit/resources/themes.dart';
import 'package:salesiq_mobilisten/salesiq_mobilisten.dart';
import '../core/route/routes.dart';
import '../core/route/routes_generator.dart';
import '../core/route/routes_observer.dart';
import 'dart:io' as io;


import '../env/environment_variables.dart';

class Klikit extends StatefulWidget {

  const Klikit({Key? key}) : super(key: key);

  @override
  State<Klikit> createState() => _KlikitState();
}

class _KlikitState extends State<Klikit> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initMobilisten();
    initSocket();

  }

  Future<void> initMobilisten() async {
    final env = getIt.get<EnvironmentVariables>();
    if (io.Platform.isIOS || io.Platform.isAndroid) {
      String appKey;
      String accessKey;
      if (io.Platform.isIOS) {
        appKey = "INSERT_IOS_APP_KEY";
        accessKey = "INSERT_IOS_ACCESS_KEY";
      } else {
        appKey = env.zohoAppKey;
        accessKey = env.zohoAppAccessKey;
      }
      ZohoSalesIQ.init(appKey, accessKey).then((_) {
        ZohoSalesIQ.showLauncher(true);
      }).catchError((error) {});
      ZohoSalesIQ.setThemeColorForiOS("#6d85fc");
    }
  }

  Future<void> initPlatformState() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: RoutesGenerator.navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: getApplicationTheme(),
      navigatorObservers: [AppRouteObserver()],
      onGenerateRoute: RoutesGenerator.generateRoute,
      initialRoute: Routes.splash,
      builder: EasyLoading.init(),
    );
  }
  initSocket(){
    final socketHandler = getIt.get<SocketHandler>();
    socketHandler.onStart();
  }
}
