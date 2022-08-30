import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';

import '../../app/size_config.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _appPreferences = getIt.get<AppPreferences>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // if(_appPreferences.isLoggedIn()){
      //   Navigator.of(context).pushReplacementNamed(Routes.base);
      // }else{
      //   Navigator.of(context).pushReplacementNamed(Routes.login);
      // }
      Navigator.of(context).pushReplacementNamed(Routes.login);
    });
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
        child: SizedBox(
          width: ScreenSizes.screenHeight,
          child: Image.asset(
            AppImages.splashLogo,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
