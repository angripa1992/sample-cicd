import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../utils/color_provider.dart';

class TabItemView extends StatelessWidget {
  final int index;
  final bool active;
  final String title;
  const TabItemView({Key? key, required this.index, required this.active, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSize.s4.rw,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s12.rSp),
          border: Border.all(
            color: active ? AppColors.blueViolet : Colors.transparent,
            width: AppSize.s1.rh,
          ),
          color: CategoriesColorProvider().color(index),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s12.rw,
            vertical: AppSize.s4.rh,
          ),
          child: Text(
           title,
            style: mediumTextStyle(
              color: AppColors.balticSea,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ),
    );
  }
}
