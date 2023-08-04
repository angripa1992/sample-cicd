import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/menu/menu_categories.dart';

class MenuCategoryTitle extends StatelessWidget {
  final MenuCategory menuCategory;

  const MenuCategoryTitle({Key? key, required this.menuCategory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightVioletTwo,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: AppSize.s12.rh,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                menuCategory.title,
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s15.rSp,
                ),
              ),
            ),
            Text(
              '${menuCategory.items.length} ${AppStrings.items.tr()}',
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s15.rSp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
