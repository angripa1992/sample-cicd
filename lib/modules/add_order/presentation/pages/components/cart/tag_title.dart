import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class TagTitleView extends StatelessWidget {
  final String title;
  final bool required;
  final bool willShowReqTag;

  const TagTitleView({
    Key? key,
    required this.title,
    required this.required,
    this.willShowReqTag = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        if (willShowReqTag)
          Container(
            margin: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s8.rw,
              vertical: AppSize.s4.rh,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s16.rSp),
              color: required ? AppColors.primaryLighter : AppColors.grey,
            ),
            child: Text(
              required ? AppStrings.required.tr() : AppStrings.optional.tr(),
              style: mediumTextStyle(
                color: required ? AppColors.primary : AppColors.greenDark,
                fontSize: AppFontSize.s10.rSp,
              ),
            ),
          ),
      ],
    );
  }
}
