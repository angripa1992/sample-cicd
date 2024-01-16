import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/resources/resource_resolver.dart';

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
  final int providerId;
  final bool parentEnabled;
  final Function(MenuOutOfStock) onMenuItemSnoozeChanged;
  final Function(bool) onMenuEnabledChanged;

  const MenuSnoozeView({
    Key? key,
    required this.menuCategoryItem,
    required this.providerId,
    required this.parentEnabled,
    required this.brandId,
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
    if (!menuCategoryItem.enabled && providerId == ZERO) {
      return InkWell(
        onTap: () => !parentEnabled
            ? null
            : showOosDialog(
                menuCategoryItem: menuCategoryItem,
                brandId: brandId,
                providerId: providerId,
                parentEnabled: parentEnabled,
                onMenuEnableChanged: onMenuEnabledChanged,
                onItemSnoozeChanged: onMenuItemSnoozeChanged,
              ),
        child: KTChip(
          text: _duration(),
          textHelperTrailingWidget: ImageResourceResolver.writeSVG.getImageWidget(width: AppSize.s12.rw, height: AppSize.s12.rh, color: AppColors.neutralB500),
          textStyle: regularTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
          strokeColor: AppColors.warningY300,
          backgroundColor: AppColors.warningY50,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw, vertical: AppSize.s2.rh),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
