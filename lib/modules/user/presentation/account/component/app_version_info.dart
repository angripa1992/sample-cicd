import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/strings.dart';

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.splashLogo,
          color: AppColors.black,
          height: AppSize.s16.rh,
          width: AppSize.s14.rw,
        ),
        SizedBox(width: AppSize.s10.rw),
        FutureBuilder<String>(
          future: _deviceInfoProvider.versionName(),
          builder: (_, version) {
            if (version.hasData) {
              return Text(
                '${AppStrings.app_version.tr()} : ${version.data!}',
                style: regularTextStyle(
                  color: AppColors.neutralB500,
                  fontSize: AppFontSize.s12.rSp,
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
