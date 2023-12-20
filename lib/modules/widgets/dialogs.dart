import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

void showValidationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback onOK,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s20.rSp,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOK();
              },
              child: Center(
                child: Text(
                  AppStrings.ok.tr(),
                  style: regularTextStyle(
                    color: AppColors.primary,
                    fontSize: AppFontSize.s18.rSp,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showAccessDeniedDialog({
  required BuildContext context,
  required String role,
}) {
  final regularStyle = regularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s14.rSp,
  );

  final boldStyle = boldTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s14.rSp,
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s16.rSp),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.access_denied.tr(),
              textAlign: TextAlign.start,
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s24.rSp,
              ),
            ),
            SizedBox(height: AppSize.s16.rh),
            Text(
              '${AppStrings.access_denied_message_header_part_one.tr()} $role ${AppStrings.access_denied_message_header_part_two.tr()}',
              textAlign: TextAlign.start,
              style: regularStyle,
            ),
            SizedBox(height: AppSize.s10.rh),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text: '${AppStrings.access_denied_message_middle_part_one.tr()} ',
                style: regularStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: 'currently only available to Branch Managers, Staffs and Cashiers',
                    style: boldStyle,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSize.s10.rh),
            Text(
              AppStrings.access_denied_message_footer.tr(),
              textAlign: TextAlign.start,
              style: regularStyle,
            ),
            SizedBox(height: AppSize.s32.rh),
            LoadingButton(
              isLoading: false,
              text: AppStrings.go_back.tr(),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
