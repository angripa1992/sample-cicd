import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
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
        _circleView('\u2713', AppColors.purpleBlue),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
          child: Text(
            'Menu',
            style: getRegularTextStyle(
              color: AppColors.balticSea,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.purpleBlue,
            thickness: AppSize.s1.rSp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
          child: _circleView(
            stepPosition == StepPosition.cart ? '2' : '\u2713',
            AppColors.purpleBlue,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: AppSize.s4.rw),
          child: Text(
            'Cart',
            style: getRegularTextStyle(
              color: stepPosition == StepPosition.cart
                  ? AppColors.purpleBlue
                  : AppColors.balticSea,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: stepPosition == StepPosition.cart
                ? AppColors.dustyGreay
                : AppColors.purpleBlue,
            thickness: AppSize.s1.rSp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
          child: _circleView(
            '3',
            stepPosition == StepPosition.checkout
                ? AppColors.purpleBlue
                : AppColors.dustyGreay,
          ),
        ),
        Text(
          'Checkout',
          style: getRegularTextStyle(
            color: stepPosition == StepPosition.checkout
                ? AppColors.purpleBlue
                : AppColors.dustyGreay,
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
            style: getRegularTextStyle(
              color: AppColors.white,
              fontSize: AppFontSize.s10.rSp,
            ),
          ),
        ),
      ),
    );
  }
}
