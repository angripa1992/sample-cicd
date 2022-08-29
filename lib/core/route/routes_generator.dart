import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/base/base_screen.dart';
import 'package:klikit/modules/onboarding/onboarding_screen.dart';

import '../../resources/strings.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: routeSettings,
        );
      case Routes.base:
        return MaterialPageRoute(
          builder: (_) => const BaseScreen(),
          settings: routeSettings,
        );
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.noRouteFound.tr()),
        ),
        body: Center(
          child: Text(AppStrings.noRouteFound.tr()),
        ),
      ),
    );
  }
}
