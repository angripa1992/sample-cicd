import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class LogoView extends StatelessWidget {
  const LogoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Image.asset(
            AppImages.klikit,
            width: 87.rw,
            height: 33.rh,
          ),
        ),
        SizedBox(
          width: AppSize.s8.rw,
        ),
        Text(
          AppStrings.cloud.tr(),
          style: getMediumTextStyle(
            color: AppColors.canaryYellow,
            fontSize: AppSize.s40.rSp,
          ),
        ),
      ],
    );
  }
}
