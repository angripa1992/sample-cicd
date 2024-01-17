import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/menu/menu_sections.dart';
import 'menu_switch_view.dart';

class MenuSectionItem extends StatefulWidget {
  final ExpandedTileController controller;
  final int index;
  final int brandId;
  final int providerID;
  final MenuSection section;
  final Function(bool) onChanged;

  const MenuSectionItem({
    Key? key,
    required this.controller,
    required this.index,
    required this.section,
    required this.onChanged,
    required this.brandId,
    required this.providerID,
  }) : super(key: key);

  @override
  State<MenuSectionItem> createState() => _MenuSectionItemState();
}

class _MenuSectionItemState extends State<MenuSectionItem> {
  @override
  void didUpdateWidget(covariant MenuSectionItem oldWidget) {
    if (widget.controller.isExpanded) {
      SegmentManager().track(
        event: SegmentEvents.MENUE_CLICK,
        properties: {
          'id': widget.section.id,
          'name': widget.section.title,
        },
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          if (widget.controller.isExpanded)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSize.s8.rSp),
                  bottomLeft: Radius.circular(AppSize.s8.rSp),
                ),
                color: AppColors.primary,
              ),
              width: AppSize.s4.rw,
            ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s12.rw,
                vertical: AppSize.s6.rh,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        MenuSwitchView(
                          menuVersion: widget.section.menuVersion,
                          enabled: widget.section.enabled,
                          parentEnabled: true,
                          providerId: widget.providerID,
                          id: widget.section.id,
                          brandId: widget.brandId,
                          type: MenuType.SECTION,
                          onMenuEnableChanged: widget.onChanged,
                        ),
                        AppSize.s12.horizontalSpacer(),
                        if (!widget.controller.isExpanded)
                          Text(
                            '${widget.index + 1}. ',
                            style: regularTextStyle(
                              color: AppColors.black,
                              fontSize: AppFontSize.s17.rSp,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            '${widget.section.title} ${widget.controller.isExpanded ? '(${widget.section.categories.length})' : ''}',
                            style: regularTextStyle(
                              color: AppColors.black,
                              fontSize: AppFontSize.s16.rSp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: AppSize.s12.rw),
                    child: Icon(
                      widget.controller.isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: AppColors.primary,
                      size: AppSize.s18.rSp,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
