import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const LoginButton({Key? key, required this.isLoading, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
            color: isLoading ? AppColors.lightViolet : AppColors.purpleBlue,
            borderRadius: BorderRadius.circular(AppSize.s8.rSp)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
            child: isLoading
                ? SizedBox(
                    height: 14.rh,
                    width: 16.rw,
                    child: CircularProgressIndicator(color: AppColors.purpleBlue),
                  )
                : Text(
                    AppStrings.login.tr(),
                    style: getBoldTextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
