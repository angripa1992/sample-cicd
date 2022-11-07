import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/sections.dart';

class MenuListItem extends StatefulWidget {
  final Sections sections;
  final int index;
  final Function(bool) onExpandedCallback;
  final ExpandedTileController controller;

  const MenuListItem(
      {Key? key,
      required this.sections,
      required this.index,
      required this.onExpandedCallback,
      required this.controller})
      : super(key: key);

  @override
  State<MenuListItem> createState() => _MenuListItemState();
}

class _MenuListItemState extends State<MenuListItem> {

  void _onChange() {
    print('${widget.controller.isExpanded}==============');
    widget.onExpandedCallback(widget.controller.isExpanded);
  }

  @override
  void initState() {
    widget.controller.addListener(_onChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.s12.rh),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
        child: ExpandedTile(
          theme: ExpandedTileThemeData(
            headerColor:
            widget.controller.isExpanded ? AppColors.purpleBlue : AppColors.white,
            headerRadius: AppSize.s8.rSp,
            headerPadding: EdgeInsets.symmetric(
              horizontal: AppSize.s12.rw,
              vertical: widget.controller.isExpanded ? AppSize.s16.rh : AppSize.ZERO,
            ),
            headerSplashColor:
            widget.controller.isExpanded ? AppColors.lightViolet : AppColors.white,
            contentBackgroundColor: Colors.white,
            contentPadding: EdgeInsets.all(4.0),
            contentRadius: 12.0,
          ),
          trailingRotation: -90,
          controller: widget.controller,
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color:
            widget.controller.isExpanded ? AppColors.white : AppColors.purpleBlue,
            size: AppSize.s16.rSp,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.index + 1}.   ${widget.sections.title}',
                style: getRegularTextStyle(
                  color: widget.controller.isExpanded
                      ? AppColors.white
                      : AppColors.purpleBlue,
                  fontSize: AppFontSize.s15.rSp,
                ),
              ),
              widget.controller.isExpanded
                  ? Text(
                      '${widget.sections.subSections.length} items',
                      style: getRegularTextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.s15.rSp,
                      ),
                    )
                  : MenuSwitchView(),
            ],
          ),
          content: Text('wjfbhwkjf'),
        ),
      ),
    );
  }
}
