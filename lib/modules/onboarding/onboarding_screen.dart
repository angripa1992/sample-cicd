import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';

import '../../app/size_config.dart';
import '../../core/route/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _appPreferences = getIt.get<AppPreferences>();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();

  final Tween<double> _turnsTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      if (_appPreferences.isLoggedIn()) {
        Navigator.of(context).pushReplacementNamed(Routes.base);
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.login);
      }
    });
    super.initState();
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
