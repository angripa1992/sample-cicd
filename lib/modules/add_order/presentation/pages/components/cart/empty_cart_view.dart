import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/assets.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s24.rw,
        vertical: AppSize.s16.rh,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.emptyCartSvg),
          SizedBox(height: AppSize.s16.rh),
          Text(
            AppStrings.your_cart_is_empty.tr(),
            style: mediumTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s20.rSp,
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Text(
            AppStrings.add_items_to_cart_msg.tr(),
            style: regularTextStyle(
              color: AppColors.balticSea,
              fontSize: AppFontSize.s16.rSp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSize.s16.rh),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleBlue, // Background color
            ),
            child: Text(
              AppStrings.add_items.tr(),
              style: mediumTextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
