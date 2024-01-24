import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:klikit/modules/add_order/utils/color_provider.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_categories.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

class MenuCategoryInfoView extends StatelessWidget {
  final MenuCategory category;
  final int index;

  const MenuCategoryInfoView({Key? key, required this.category, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rSp),
        color: CategoriesColorProvider().color(index),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 12.rw),
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.title,
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: 14.rSp,
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16.rSp,
                  color: AppColors.black,
                ),
                SizedBox(width: 4.rw),
                Text(
                  MenuAvailableTimeProvider().availableTime(category.availableTimes),
                  style: regularTextStyle(color: AppColors.black, fontSize: 14.rSp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
