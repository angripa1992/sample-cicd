import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_category_list.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_section_item.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/menu/menu_sections.dart';

class MenuListView extends StatefulWidget {
  final List<MenuSection> sections;
  final int brandID;
  final int branchID;

  const MenuListView({
    Key? key,
    required this.sections,
    required this.brandID,
    required this.branchID,
  }) : super(key: key);

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  void _listen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedTileList.separated(
      itemCount: widget.sections.length,
      itemBuilder: (context, index, controller) {
        controller.addListener(_listen);
        return ExpandedTile(
          theme: ExpandedTileThemeData(
            headerColor: Colors.transparent,
            headerRadius: AppSize.s8.rSp,
            headerPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            trailingPadding: EdgeInsets.zero,
            leadingPadding: EdgeInsets.zero,
            headerSplashColor: AppColors.white,
            contentBackgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            contentRadius: AppSize.s8.rSp,
          ),
          controller: controller,
          trailing: const SizedBox(),
          title: MenuSectionItem(
            controller: controller,
            index: index,
            brandId: widget.brandID,
            branchId: widget.branchID,
            section: widget.sections[index],
            onChanged: (enabled) {
              setState(() {
                widget.sections[index].enabled = enabled;
              });
              SegmentManager().track(
                event: SegmentEvents.MENUE_TOGGLE,
                properties: {
                  'id': widget.sections[index].id,
                  'name': widget.sections[index].title,
                  'enabled': enabled ? 'Yes' : 'No',
                },
              );
            },
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
            child: MenuCategoryListView(
              key: UniqueKey(),
              categories: widget.sections[index].categories,
              parentEnabled: widget.sections[index].enabled,
              onChanged: (modifiedSubSections) {
                setState(() {
                  widget.sections[index].categories = modifiedSubSections;
                });
              },
              brandID: widget.brandID,
              branchID: widget.branchID,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: AppSize.s8.rh,
        );
      },
    );
  }
}
