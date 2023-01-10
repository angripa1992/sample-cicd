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
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import 'menu_switch_view.dart';

class MenuItemTitle extends StatefulWidget {
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
  State<MenuItemTitle> createState() => _MenuItemTitleState();
}

class _MenuItemTitleState extends State<MenuItemTitle> {
  @override
  void didUpdateWidget(covariant MenuItemTitle oldWidget) {
    if (widget.controller.isExpanded) {
      SegmentManager().track(
        event: SegmentEvents.MENUE_CLICK,
        properties: {
          'id': widget.sections.id,
          'name': widget.sections.title,
        },
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          widget.controller.isExpanded ? AppColors.purpleBlue : AppColors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical:
              widget.controller.isExpanded ? AppSize.s16.rh : AppSize.s4.rh,
        ),
        child: Row(
          children: [
            if (!widget.controller.isExpanded)
              MenuSwitchView(
                enabled: widget.sections.enabled,
                parentEnabled: true,
                onChanged: widget.onChanged,
                id: widget.sections.id,
                brandId: widget.brandId,
                type: MenuType.SECTION,
              ),
            if (!widget.controller.isExpanded) SizedBox(width: AppSize.s12.rw),
            Expanded(
              child: Row(
                children: [
                  Text(
                    '${widget.index + 1}.',
                    style: getRegularTextStyle(
                      color: widget.controller.isExpanded
                          ? AppColors.white
                          : AppColors.purpleBlue,
                      fontSize: AppFontSize.s15.rSp,
                    ),
                  ),
                  SizedBox(width: AppSize.s4.rw),
                  Expanded(
                    child: Text(
                      widget.sections.title,
                      style: getRegularTextStyle(
                        color: widget.controller.isExpanded
                            ? AppColors.white
                            : AppColors.purpleBlue,
                        fontSize: AppFontSize.s15.rSp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.controller.isExpanded)
              Text(
                '${widget.sections.subSections.length} ${AppStrings.items.tr()}',
                style: getRegularTextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSize.s15.rSp,
                ),
              ),
            Padding(
              padding: EdgeInsets.only(left: AppSize.s12.rw),
              child: Icon(
                widget.controller.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: widget.controller.isExpanded
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
