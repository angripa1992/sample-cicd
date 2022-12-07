import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/device_information_provider.dart';

import '../../../../../app/di.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class AppVersionInfo extends StatelessWidget {
  final _deviceInfoProvider = getIt.get<DeviceInfoProvider>();

  AppVersionInfo({Key? key}) : super(key: key);

  final _textStyle = getBoldTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<String>(
          future: _deviceInfoProvider.appName(),
          builder: (_, name) {
           if(name.hasData){
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
            if(version.hasData){
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
