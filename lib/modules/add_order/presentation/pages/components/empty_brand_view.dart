import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class EmptyBrandView extends StatelessWidget {
  const EmptyBrandView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s18.rh,
        horizontal: AppSize.s16.rw,
      ),
      child: Column(
        children: [
          SvgPicture.asset(AppIcons.emptyBrand),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
            child: Text(
              'Select a brand name to start working on the order',
              textAlign: TextAlign.center,
              style: getMediumTextStyle(
                color: AppColors.purpleBlue,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          ),
          Text(
            'Click on the button at the top to select a brand name',
            textAlign: TextAlign.center,
            style: getRegularTextStyle(
              color: AppColors.coolGrey,
              fontSize: AppFontSize.s12.rSp,
            ),
          ),
        ],
      ),
    );
  }
}
