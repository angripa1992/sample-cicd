import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/notification/notification_handler.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';

import '../../app/size_config.dart';
import '../../core/route/routes.dart';
import '../../notification/fcm_service.dart';
import '../../notification/fcm_token_manager.dart';
import '../../notification/local_notification_service.dart';
import '../widgets/snackbars.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _fcmTokenManager = getIt.get<FcmTokenManager>();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  final Tween<double> _turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted) {
          final NotificationAppLaunchDetails? notificationAppLaunchDetails =
              await flutterLocalNotificationsPlugin
                  .getNotificationAppLaunchDetails();
          if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
            NotificationHandler().handleBackgroundNotification(
                notificationAppLaunchDetails?.notificationResponse?.payload);
          } else {
            _gotoNextScreen();
          }
        }
      },
    );
    super.initState();
  }

  void _gotoNextScreen() {
    Timer(const Duration(seconds: 2), () {
      if (SessionManager().isLoggedIn()) {
        _registerFcmToken().then((value) {
          Navigator.of(context)
              .pushReplacementNamed(Routes.base, arguments: null);
        });
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
    });
  }

  Future _registerFcmToken() async {
    final fcmToken = await FcmService().getFcmToken();
    final response = await _fcmTokenManager.registerToken(fcmToken ?? '');
    response.fold(
      (failure) {
        showApiErrorSnackBar(context, failure);
      },
      (success) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenSizes.screenWidth = size.width;
    ScreenSizes.screenHeight = size.height;
    ScreenSizes.statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: RotationTransition(
          turns: _turnsTween.animate(_controller),
          child: SizedBox(
            child: Image.asset(
              AppImages.splashLogo,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}
