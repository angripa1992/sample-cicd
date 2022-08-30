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

void showConnectivitySnackBar(BuildContext context) {
  dismissCurrentSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.noInternetError.tr(),
              style: getBoldTextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
          ),
          Icon(
            Icons.signal_wifi_connected_no_internet_4,
            color: AppColors.white,
          ),
        ],
      ),
      duration: const Duration(hours: 1),
      backgroundColor: AppColors.red,
    ),
  );
}

void showErrorSnackBar(BuildContext context,String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: getBoldTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s15.rSp,
        ),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.red,
    ),
  );
}

void showSuccessSnackBar(BuildContext context,String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: getBoldTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s15.rSp,
        ),
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: AppColors.primary,
    ),
  );
}