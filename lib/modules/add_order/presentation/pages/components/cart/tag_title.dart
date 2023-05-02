import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class TagTitleView extends StatelessWidget {
  final String title;
  final bool required;
  const TagTitleView({Key? key, required this.title, required this.required}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: getMediumTextStyle(
            color: AppColors.balticSea,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s8.rw,
            vertical: AppSize.s2.rh,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s16.rSp),
            color: AppColors.lightVioletTwo,
          ),
          child: Text(
            required ? 'Required' : 'Optional',
            style: getMediumTextStyle(
              color: required ? AppColors.purpleBlue : AppColors.balticSea,
              fontSize: AppFontSize.s10.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
