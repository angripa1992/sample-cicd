import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/assets.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
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
            'Your cart is empty!',
            style: getMediumTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Text(
            'Take your time to explore and add items to your cart. Once you are ready, proceed to checkout to place oder',
            style: getRegularTextStyle(color: AppColors.balticSea),
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
              'Add items',
              style: getMediumTextStyle(
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
