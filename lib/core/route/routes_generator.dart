import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/base/base_screen.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/manage_items_screen.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/manage_modifiers_screen.dart';
import 'package:klikit/modules/onboarding/onboarding_screen.dart';
import 'package:klikit/modules/user/presentation/chnage_password/change_password_screen.dart';
import 'package:klikit/modules/user/presentation/forget/forget_screen.dart';
import 'package:klikit/modules/user/presentation/login/login_page.dart';
import 'package:klikit/modules/widgets/web_view_screen.dart';
import 'package:klikit/printer/presentation/printer_connection_settings_page.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';

import '../../modules/base/chnage_language_cubit.dart';
import '../../modules/support/contact_support.dart';
import '../../modules/user/presentation/account/component/device_setting_view.dart';
import '../../modules/user/presentation/account/component/edit_profile_screen.dart';

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
          builder: (_) => const LoginScreen(),
          settings: routeSettings,
        );
      case Routes.base:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt.get<BaseScreenCubit>()),
              BlocProvider(create: (_) => getIt.get<PrinterSettingCubit>()),
              BlocProvider(create: (_) => getIt.get<ChangeLanguageCubit>()),
            ],
            child: const BaseScreen(),
          ),
          settings: routeSettings,
        );
      case Routes.contactSupport:
        return MaterialPageRoute(
          builder: (_) => const ContactSupportScreen(),
          settings: routeSettings,
        );
      case Routes.webView:
        return MaterialPageRoute(
          builder: (_) => const WebViewScreen(),
          settings: routeSettings,
        );
      case Routes.forget:
        return MaterialPageRoute(
          builder: (_) => const ForgetScreen(),
          settings: routeSettings,
        );
      case Routes.changePassword:
        return MaterialPageRoute(
          builder: (_) => const ChangePasswordScreen(),
          settings: routeSettings,
        );
      case Routes.manageItems:
        return MaterialPageRoute(
          builder: (_) => const ManageItemsScreen(),
          settings: routeSettings,
        );
      case Routes.manageModifiers:
        return MaterialPageRoute(
          builder: (_) => const ManageModifiersScreen(),
          settings: routeSettings,
        );
      case Routes.editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
          settings: routeSettings,
        );
      case Routes.deviceSetting:
        return MaterialPageRoute(
          builder: (_) => const DeviceSettingScreen(),
          settings: routeSettings,
        );
      case Routes.printerSettings:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (_) => getIt.get<UpdatePrinterSettingCubit>()),
              BlocProvider(create: (_) => getIt.get<PrinterSettingCubit>()),
            ],
            child: const PrinterConnectionSettingPage(),
          ),
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
          title: const Text(''),
        ),
        body: const Center(
          child: Text(''),
        ),
      ),
    );
  }
}
