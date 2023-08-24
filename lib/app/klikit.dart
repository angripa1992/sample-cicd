import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/resources/themes.dart';
import '../core/route/routes.dart';
import '../core/route/routes_generator.dart';
import '../core/route/routes_observer.dart';

class Klikit extends StatelessWidget {
  const Klikit({Key? key}) : super(key: key);

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
}
