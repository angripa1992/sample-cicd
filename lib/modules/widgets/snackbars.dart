import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';

import '../../resources/fonts.dart';
import '../../resources/styles.dart';

void dismissCurrentSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}

void showConnectivitySnackBar(BuildContext context, bool isOnline) {
  dismissCurrentSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Expanded(
            child: Text(
              isOnline
                  ? AppStrings.internet_connection_reestablished.tr()
                  : AppStrings.noInternetError.tr(),
              style: getRegularTextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
          ),
          Icon(
            isOnline ? Icons.wifi :Icons.wifi_off,
            color: AppColors.white,
          ),
        ],
      ),
      duration: isOnline ? const Duration(seconds: 3) : const Duration(hours: 1),
      backgroundColor: isOnline ? AppColors.green :AppColors.red,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: getRegularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s15.rSp,
        ),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.red,
    ),
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: getRegularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s15.rSp,
        ),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.purpleBlue,
    ),
  );
}
