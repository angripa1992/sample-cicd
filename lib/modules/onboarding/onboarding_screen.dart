import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/route/routes.dart';

import '../../app/size_config.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenSizes.screenWidth = size.width;
    ScreenSizes.screenHeight = size.height;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            Navigator.of(context).pushReplacementNamed(Routes.base);
          },
          child: Text('Goto Base Screen'),
        ),
      ),
    );
  }
}
