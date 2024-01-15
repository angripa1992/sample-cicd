import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_switch.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/menu/menu_categories.dart';

class MenuCategoryTitle extends StatelessWidget {
  final MenuCategory menuCategory;

  const MenuCategoryTitle({Key? key, required this.menuCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw, vertical: AppSize.s8.rh),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuCategory.title,
                  style: mediumTextStyle(
                    color: AppColors.neutralB600,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
                Text(
                  '${menuCategory.items.length} ${AppStrings.items.tr()}',
                  style: regularTextStyle(
                    color: AppColors.neutralB300,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                )
              ],
            ),
          ),
          KTSwitch(
            width: 44.rw,
            height: 22.rh,
            controller: ValueNotifier<bool>(menuCategory.enabled),
            activeColor: AppColors.primaryP300,
            onChanged: (enabled) {},
          )
        ],
      ),
    );
  }
}
