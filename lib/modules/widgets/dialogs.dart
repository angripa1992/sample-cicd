import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../app/constants.dart';
import '../../core/route/routes_generator.dart';

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
                fontSize: AppFontSize.s20.rSp,
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
                fontSize: AppFontSize.s16.rSp,
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
                          fontSize: AppFontSize.s18.rSp,
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
                          fontSize: AppFontSize.s18.rSp,
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: getMediumTextStyle(
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
              style: getRegularTextStyle(
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
                  style: getRegularTextStyle(
                    color: AppColors.purpleBlue,
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
  final regularStyle = getRegularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s14.rSp,
  );

  final boldStyle = getBoldTextStyle(
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
              style: getMediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s24.rSp,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            Text(
              '${AppStrings.access_denied_message_header_part_one.tr()} $role ${AppStrings.access_denied_message_header_part_two.tr()}',
              textAlign: TextAlign.start,
              style: regularStyle,
            ),
            SizedBox(
              height: AppSize.s10.rh,
            ),
            RichText(
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              text: TextSpan(
                text:
                    '${AppStrings.access_denied_message_middle_part_one.tr()} ',
                style: regularStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: AppStrings.access_denied_message_middle_part_two.tr(),
                    style: boldStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppSize.s10.rh,
            ),
            Text(
              AppStrings.access_denied_message_footer.tr(),
              textAlign: TextAlign.start,
              style: regularStyle,
            ),
            SizedBox(
              height: AppSize.s32.rh,
            ),
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


void showNoDeviceConnectedDialog({
  required int connectionType,
  required VoidCallback onOK,
}) {
  showDialog(
    context: RoutesGenerator.navigatorKey.currentState!.context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              connectionType == ConnectionType.BLUETOOTH
                  ? 'No Bluetooth Devices'
                  : 'No USB Devices',
              style: getMediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s18.rSp,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            Text(
              connectionType == ConnectionType.BLUETOOTH
                  ? AppStrings.no_bluetooth_devices_message.tr()
                  : AppStrings.no_usb_devices_message.tr(),
              textAlign: TextAlign.center,
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
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
                  style: getRegularTextStyle(
                    color: AppColors.purpleBlue,
                    fontSize: AppFontSize.s16.rSp,
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
