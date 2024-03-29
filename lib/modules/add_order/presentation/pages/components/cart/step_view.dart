import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

enum StepPosition { menu, cart, checkout }

class StepView extends StatelessWidget {
  final StepPosition stepPosition;

  const StepView({Key? key, required this.stepPosition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleView('\u2713', AppColors.primary),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
          child: Text(
            AppStrings.menu.tr(),
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.primary,
            thickness: AppSize.s1.rSp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
          child: _circleView(
            stepPosition == StepPosition.cart ? '2' : '\u2713',
            AppColors.primary,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: AppSize.s4.rw),
          child: Text(
            AppStrings.cart.tr(),
            style: regularTextStyle(
              color: stepPosition == StepPosition.cart
                  ? AppColors.primary
                  : AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: stepPosition == StepPosition.cart
                ? AppColors.greyDarker
                : AppColors.primary,
            thickness: AppSize.s1.rSp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
          child: _circleView(
            '3',
            stepPosition == StepPosition.checkout
                ? AppColors.primary
                : AppColors.greyDarker,
          ),
        ),
        Text(
          AppStrings.checkout.tr(),
          style: regularTextStyle(
            color: stepPosition == StepPosition.checkout
                ? AppColors.primary
                : AppColors.greyDarker,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ],
    );
  }

  Widget _circleView(String text, Color color) {
    return Container(
      height: AppSize.s18.rh,
      width: AppSize.s18.rw,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: regularTextStyle(
              color: AppColors.white,
              fontSize: AppFontSize.s10.rSp,
            ),
          ),
        ),
      ),
    );
  }
}
