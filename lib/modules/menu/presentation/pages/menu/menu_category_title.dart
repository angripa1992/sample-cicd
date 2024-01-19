import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';
import 'package:klikit/segments/event_manager.dart';
import 'package:klikit/segments/segemnt_data_provider.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/menu/menu_categories.dart';

class MenuCategoryTitle extends StatelessWidget {
  final MenuCategory menuCategory;
  final bool parentEnabled;
  final int brandID;
  final int branchID;
  final Function(MenuCategory) onChanged;

  const MenuCategoryTitle({
    Key? key,
    required this.menuCategory,
    required this.parentEnabled,
    required this.brandID,
    required this.branchID,
    required this.onChanged,
  }) : super(key: key);

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
          MenuSwitchView(
            menuVersion: menuCategory.menuVersion,
            enabled: menuCategory.enabled,
            parentEnabled: parentEnabled,
            id: menuCategory.id,
            brandId: brandID,
            branchId: branchID,
            type: MenuType.CATEGORY,
            switchWidth: 44.rw,
            switchHeight: 22.rh,
            onMenuEnableChanged: (enabled) {
              menuCategory.enabled = enabled;
              onChanged(menuCategory);
              SegmentManager().track(
                event: SegmentEvents.CATEGORY_TOGGLE,
                properties: {
                  'id': menuCategory.id,
                  'name': menuCategory.title,
                  'enabled': enabled ? 'Yes' : 'No',
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
