import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/di.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import '../provider/device_information_provider.dart';
import '../route/routes_generator.dart';

class AppUpdateManager{
  static final _instance = AppUpdateManager._internal();
  factory AppUpdateManager() => _instance;
  AppUpdateManager._internal();

  bool _isDialogAlreadyShowing = false;

  void showAppUpdateDialog(){
    if(!_isDialogAlreadyShowing){
      _isDialogAlreadyShowing = true;
      _showDialog();
    }
  }

  void _gotoPlayStore() async{
    final deviceInfoProvider = getIt.get<DeviceInfoProvider>();
    final packageName = await deviceInfoProvider.packageName();
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid ? packageName : 'YOUR_IOS_APP_ID';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void _showDialog(){
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
                'Update Required',
                style: getMediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s20.rSp,
                ),
              ),
              SizedBox(
                height: AppSize.s16.rh,
              ),
              Text(
                'Please update app',
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
                  _gotoPlayStore();
                },
                child: Center(
                  child: Text(
                    'Update App',
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
    ).then((value) => _isDialogAlreadyShowing = false);
  }
}