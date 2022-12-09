import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/resources/assets.dart';

import '../../../../../app/di.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class AppVersionInfo extends StatelessWidget {
  final _deviceInfoProvider = getIt.get<DeviceInfoProvider>();

  AppVersionInfo({Key? key}) : super(key: key);

  final _textStyle = getMediumTextStyle(
    color: AppColors.darkViolet,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.splashLogo,
          color: AppColors.darkViolet,
          height: AppSize.s24.rh,
          width: AppSize.s24.rw,
        ),
        SizedBox(width: AppSize.s8.rw),
        FutureBuilder<String>(
          future: _deviceInfoProvider.appName(),
          builder: (_, name) {
            if (name.hasData) {
              return Text(
                name.data!,
                style: _textStyle,
              );
            }
            return const SizedBox();
          },
        ),
        SizedBox(width: AppSize.s4.rw),
        FutureBuilder<String>(
          future: _deviceInfoProvider.versionName(),
          builder: (_, version) {
            if (version.hasData) {
              return Text(
                version.data!,
                style: _textStyle,
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
