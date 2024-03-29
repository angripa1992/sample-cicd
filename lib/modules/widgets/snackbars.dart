import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../resources/fonts.dart';
import '../../resources/styles.dart';

void dismissCurrentSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
}

void showConnectivitySnackBar(BuildContext context, bool isOnline) {
  dismissCurrentSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              isOnline ? AppStrings.internet_connection_reestablished.tr() : AppStrings.noInternetError.tr(),
              style: regularTextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
          ),
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: AppColors.white,
          ),
        ],
      ),
      duration: isOnline ? const Duration(seconds: 1) : const Duration(hours: 1),
      backgroundColor: isOnline ? AppColors.green : AppColors.red,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  dismissCurrentSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: regularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s15.rSp,
        ),
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.red,
    ),
  );
}

void showApiErrorSnackBar(BuildContext context, Failure failure) {
  if (failure.code == ResponseCode.UPDATE_REQUIRED) {
    return;
  }
  dismissCurrentSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        failure.message,
        style: regularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s15.rSp,
        ),
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.red,
    ),
  );
}

void showSuccessSnackBar(BuildContext? context, String message, {EdgeInsets? toastMargin}) {
  ScaffoldMessenger.of(context ?? RoutesGenerator.navigatorKey.currentState!.context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: regularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s15.rSp,
        ),
      ),
      margin: toastMargin,
      behavior: toastMargin != null ? SnackBarBehavior.floating : null,
      duration: Duration(milliseconds: toastMargin != null ? 500 : 1000),
      backgroundColor: AppColors.green,
    ),
  );
}

void showLoadingSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          SizedBox(
            height: AppSize.s18.rh,
            width: AppSize.s20.rw,
            child: CircularProgressIndicator(
              color: AppColors.white,
            ),
          ),
          SizedBox(width: AppSize.s14.rw),
          Text(
            AppStrings.please_wait.tr(),
            style: regularTextStyle(
              color: AppColors.white,
              fontSize: AppFontSize.s15.rSp,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.primary,
    ),
  );
}
