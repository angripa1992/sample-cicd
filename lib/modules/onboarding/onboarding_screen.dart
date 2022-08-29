import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed(Routes.base);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenSizes.screenWidth = size.width;
    ScreenSizes.screenHeight = size.height;
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
