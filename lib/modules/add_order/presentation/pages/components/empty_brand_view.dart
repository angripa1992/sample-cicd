import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
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
              AppStrings.select_brand_name_msg.tr(),
              textAlign: TextAlign.center,
              style: getMediumTextStyle(
                color: AppColors.purpleBlue,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          ),
          Text(
            AppStrings.click_button_to_select_brand.tr(),
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
