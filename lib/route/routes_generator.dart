import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/route/routes.dart';

import '../resources/strings.dart';
import '../splash/splash_screen.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splash:
        return MaterialPageRoute(
            builder: (_) => const SplashScreen(), settings: routeSettings);
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title:  Text(AppStrings.noRouteFound.tr()),
        ),
        body:  Center(
          child: Text(AppStrings.noRouteFound.tr()),
        ),
      ),
    );
  }
}
