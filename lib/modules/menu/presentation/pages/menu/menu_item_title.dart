import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/sections.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import 'menu_switch_view.dart';

class MenuItemTitle extends StatelessWidget {
  final ExpandedTileController controller;
  final int index;
  final int brandId;
  final Sections sections;
  final Function(bool) onChanged;

  const MenuItemTitle(
      {Key? key,
      required this.controller,
      required this.index,
      required this.sections,
      required this.onChanged,
      required this.brandId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: controller.isExpanded ? AppColors.purpleBlue : AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: controller.isExpanded ? AppSize.s16.rh : AppSize.s4.rh,
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    '${index + 1}.',
                    style: getRegularTextStyle(
                      color: controller.isExpanded
                          ? AppColors.white
                          : AppColors.purpleBlue,
                      fontSize: AppFontSize.s15.rSp,
                    ),
                  ),
                  SizedBox(width: AppSize.s4.rw),
                  Expanded(
                    child: Text(
                      sections.title,
                      style: getRegularTextStyle(
                        color: controller.isExpanded
                            ? AppColors.white
                            : AppColors.purpleBlue,
                        fontSize: AppFontSize.s15.rSp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            controller.isExpanded
                ? Text(
                    '${sections.subSections.length} ${AppStrings.items.tr()}',
                    style: getRegularTextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSize.s15.rSp,
                    ),
                  )
                : MenuSwitchView(
                    enabled: sections.enabled,
                    parentEnabled: true,
                    onChanged: onChanged,
                    id: sections.id,
                    brandId: brandId,
                    type: MenuType.SECTION,
                  ),
            Padding(
              padding: EdgeInsets.only(left: AppSize.s12.rw),
              child: Icon(
                controller.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: controller.isExpanded
                    ? AppColors.white
                    : AppColors.purpleBlue,
                size: AppSize.s18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
