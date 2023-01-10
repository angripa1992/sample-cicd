import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_item_title.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/sub_menu_list_view.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/sections.dart';

class MenuListView extends StatefulWidget {
  final List<Sections> sections;
  final int brandID;

  const MenuListView({Key? key, required this.sections, required this.brandID})
      : super(key: key);

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  void _listen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedTileList.seperated(
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
          title: MenuItemTitle(
            controller: controller,
            index: index,
            sections: widget.sections[index],
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
            brandId: widget.brandID,
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
            child: SubMenuListView(
              subSections: widget.sections[index].subSections,
              parentEnabled: widget.sections[index].enabled,
              onChanged: (modifiedSubSections) {
                setState(() {
                  widget.sections[index].subSections = modifiedSubSections;
                });
              },
              brandID: widget.brandID,
            ),
          ),
        );
      },
      seperatorBuilder: (context, _) {
        return SizedBox(
          height: AppSize.s12.rh,
        );
      },
    );
  }
}
