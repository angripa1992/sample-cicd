import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/menu/menu_item.dart';
import '../../../domain/entities/menu/menu_out_of_stock.dart';
import 'oos_settings.dart';

class MenuSnoozeView extends StatelessWidget {
  final MenuCategoryItem menuCategoryItem;
  final int brandId;
  final int branchID;
  final bool parentEnabled;
  final Function(MenuOutOfStock) onMenuItemSnoozeChanged;
  final Function(bool) onMenuEnabledChanged;

  const MenuSnoozeView({
    Key? key,
    required this.menuCategoryItem,
    required this.parentEnabled,
    required this.brandId,
    required this.branchID,
    required this.onMenuItemSnoozeChanged,
    required this.onMenuEnabledChanged,
  }) : super(key: key);

  String _duration() {
    final duration = menuCategoryItem.outOfStock.menuSnooze.duration;
    if (duration == 24) {
      return '1 ${AppStrings.day.tr()}';
    } else if (duration == 72) {
      return '3 ${AppStrings.day.tr()}';
    } else if (duration == 168) {
      return '7 ${AppStrings.day.tr()}';
    } else if (duration == 0) {
      return AppStrings.untill_trun_back_on.tr();
    } else {
      return '$duration ${AppStrings.hours.tr()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return !menuCategoryItem.enabled
        ? InkWell(
            onTap: () => !parentEnabled
                ? null
                : showOosDialog(
                    menuCategoryItem: menuCategoryItem,
                    brandId: brandId,
                    branchID: branchID,
                    parentEnabled: parentEnabled,
                    onMenuEnableChanged: onMenuEnabledChanged,
                    onItemSnoozeChanged: onMenuItemSnoozeChanged,
                  ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s24.rSp),
                border: Border.all(color: AppColors.greyDarker),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s4.rh,
                  horizontal: AppSize.s8.rw,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        _duration(),
                        style: mediumTextStyle(
                          color: AppColors.yellowDark,
                          fontSize: AppFontSize.s12.rSp,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.yellowDark,
                      size: AppSize.s16.rSp,
                    )
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
