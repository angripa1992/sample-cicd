import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/sections.dart';

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
  final int providerID;
  final Sections sections;
  final Function(bool) onChanged;

  const MenuItemTitle({
    Key? key,
    required this.controller,
    required this.index,
    required this.sections,
    required this.onChanged,
    required this.brandId,
    required this.providerID,
  }) : super(key: key);

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
      //color: widget.controller.isExpanded ? AppColors.purpleBlue : AppColors.white,
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (widget.controller.isExpanded)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.s8.rSp),
                    bottomLeft: Radius.circular(AppSize.s8.rSp),
                  ),
                  color: AppColors.purpleBlue,
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
                    Padding(
                      padding: EdgeInsets.only(left: AppSize.s12.rw),
                      child: Icon(
                        widget.controller.isExpanded
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: AppColors.purpleBlue,
                        size: AppSize.s18,
                      ),
                    ),
                    SizedBox(width: AppSize.s24.rw),
                    Expanded(
                      child: Row(
                        children: [
                          if (!widget.controller.isExpanded)
                            Text(
                              '${widget.index + 1}. ',
                              style: getRegularTextStyle(
                                color: AppColors.balticSea,
                                fontSize: AppFontSize.s17.rSp,
                              ),
                            ),
                          SizedBox(width: AppSize.s4.rw),
                          Expanded(
                            child: Text(
                              '${widget.sections.title} ${widget.controller.isExpanded ? '(${widget.sections.subSections.length})' : ''}',
                              style: getRegularTextStyle(
                                color: AppColors.balticSea,
                                fontSize: AppFontSize.s16.rSp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MenuSwitchView(
                      enabled: widget.sections.enabled,
                      parentEnabled: true,
                      providerId: widget.providerID,
                      onChanged: widget.onChanged,
                      id: widget.sections.id,
                      brandId: widget.brandId,
                      type: MenuType.SECTION,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
