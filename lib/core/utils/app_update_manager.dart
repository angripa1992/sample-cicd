import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/public_rest_client.dart';
import 'package:klikit/env/environment_variables.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/di.dart';
import '../../app/enums.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import '../provider/device_information_provider.dart';
import '../route/routes_generator.dart';

class AppUpdateManager {
  static final _instance = AppUpdateManager._internal();

  factory AppUpdateManager() => _instance;

  AppUpdateManager._internal();

  bool _isDialogAlreadyShowing = false;

  void showAppUpdateDialog() {
    if (!_isDialogAlreadyShowing) {
      _isDialogAlreadyShowing = true;
      _showDialog();
    }
  }

  Future<bool> checkForUpdate() async {
    try {
      final baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
      final currentVersionStr = await getIt.get<DeviceInfoProvider>().versionCode();
      final currentVersion = num.parse(currentVersionStr);
      final response = await PublicRestClient().request('$baseUrl/v1/appversion', Method.GET, null);
      final updatedVersionCode = response['appversion_android'];
      return updatedVersionCode > currentVersion;
    } catch (error) {
      return false;
    }
  }

  Future<void> gotoPlayStore() async {
    final deviceInfoProvider = getIt.get<DeviceInfoProvider>();
    final packageName = await deviceInfoProvider.packageName();
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? packageName : 'YOUR_IOS_APP_ID';
      final url = Uri.parse(
        Platform.isAndroid ? "market://details?id=$appId" : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void _showDialog() {
    showDialog(
      context: RoutesGenerator.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.system_update,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSize.s8),
              Text(
                AppStrings.update_required.tr(),
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s18.rSp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSize.s10),
                child: Text(
                  AppStrings.app_update_msg.tr(),
                  textAlign: TextAlign.center,
                  style: regularTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  gotoPlayStore();
                },
                child: Center(
                  child: Text(
                    AppStrings.update_app.tr(),
                    style: regularTextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) => _isDialogAlreadyShowing = false);
  }
}
