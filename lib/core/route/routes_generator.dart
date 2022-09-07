import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/base/base_screen.dart';
import 'package:klikit/modules/home/presentation/support/contact_support.dart';
import 'package:klikit/modules/onboarding/onboarding_screen.dart';
import 'package:klikit/modules/user/presentation/forget/forget_screen.dart';
import 'package:klikit/modules/user/presentation/login/login_page.dart';
import 'package:klikit/modules/widgets/web_view_screen.dart';

import '../../resources/strings.dart';

class RoutesGenerator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: routeSettings,
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: routeSettings,
        );
      case Routes.base:
        return MaterialPageRoute(
          builder: (_) => const BaseScreen(),
          settings: routeSettings,
        );
      case Routes.contactSupport:
        return MaterialPageRoute(
          builder: (_) => const ContactSupportScreen(),
          settings: routeSettings,
        );
      case Routes.webView:
        return MaterialPageRoute(
          builder: (_) =>  const WebViewScreen(),
          settings: routeSettings,
        );
        case Routes.forget:
        return MaterialPageRoute(
          builder: (_) =>  const ForgetScreen(),
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
