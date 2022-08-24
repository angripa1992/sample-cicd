import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/resources/themes.dart';
import 'package:klikit/route/routes.dart';
import 'package:klikit/route/routes_generator.dart';
import 'package:klikit/route/routes_observer.dart';

class Klikit extends StatelessWidget {
  const Klikit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: getApplicationTheme(),
      navigatorObservers: [AppRouteObserver()],
      onGenerateRoute: RoutesGenerator.generateRoute,
      initialRoute: Routes.splash,
    );
  }
}
