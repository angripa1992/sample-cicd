import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: Text(AppStrings.account.tr()),
        titleTextStyle: getAppBarTextStyle(),
        centerTitle: true,
        flexibleSpace: getAppBarBackground(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
          width: ScreenSizes.screenWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s18.rh,horizontal: AppSize.s20.rw,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppStrings.edit_profile.tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
