import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/menu/menu_categories.dart';
import '../../../utils/available_time_provider.dart';
import '../../../utils/color_provider.dart';

class MenuCategoryInfoView extends StatelessWidget {
  final MenuCategory category;
  final int index;

  const MenuCategoryInfoView(
      {Key? key, required this.category, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: CategoriesColorProvider().color(index),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s10.rh,
          horizontal: AppSize.s12.rw,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.title,
                style: mediumTextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: AppSize.s16.rSp,
                  color: AppColors.purpleBlue,
                ),
                SizedBox(width: AppSize.s4.rw),
                Text(
                  AvailableTimeProvider()
                      .availableTime(category.availableTimes),
                  style: regularTextStyle(color: AppColors.purpleBlue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
