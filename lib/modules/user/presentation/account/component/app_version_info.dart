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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          AppImages.splashLogo,
          color: AppColors.black,
          height: AppSize.s24.rh,
          width: AppSize.s24.rw,
        ),
        SizedBox(width: AppSize.s16.rw),
        FutureBuilder<String>(
          future: _deviceInfoProvider.versionName(),
          builder: (_, version) {
            if (version.hasData) {
              return Text(
                'App Version :  ${version.data!}',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
