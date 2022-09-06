import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

void showLogoutDialog(
    {required BuildContext context, required VoidCallback onLogout}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.logout.tr(),
              style: getMediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s20,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            Text(
              AppStrings.logout_confirm_message.tr(),
              textAlign: TextAlign.center,
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            const Divider(),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: Text(
                        AppStrings.cancel.tr(),
                        style: getRegularTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s16,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onLogout();
                    },
                    child: Center(
                      child: Text(
                        AppStrings.logout.tr(),
                        style: getRegularTextStyle(
                          color: AppColors.purpleBlue,
                          fontSize: AppFontSize.s16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
