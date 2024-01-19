import 'package:badges/badges.dart' as bg;
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/notification/inapp/in_app_notification_handler.dart';
import 'package:klikit/resources/asset_resolver/svg_image_resource.dart';

import '../../resources/colors.dart';
import '../../resources/values.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({
    required this.svgResourcePath,
    required this.text,
    required this.index,
  });

  final String svgResourcePath;
  final String text;
  final int index;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    super.key,
    required this.initialIndex,
    required this.items,
    required this.centerItemText,
    this.height = 60.0,
    this.iconSize = 24.0,
    required this.backgroundColor,
    required this.color,
    required this.selectedColor,
    required this.notchedShape,
    required this.onTabSelected,
  }) {
    assert(items.length == 2 || items.length == 5 || items.length == 4);
  }

  final int initialIndex;
  final List<FABBottomAppBarItem> items;
  final String centerItemText;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final NotchedShape notchedShape;
  final ValueChanged<int> onTabSelected;

  @override
  State<StatefulWidget> createState() => FABBottomAppBarState();
}

class FABBottomAppBarState extends State<FABBottomAppBar> {
  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FABBottomAppBar oldWidget) {
    _selectedIndex = widget.initialIndex;
    super.didUpdateWidget(oldWidget);
  }

  _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        item: widget.items[index],
        onPressed: _updateIndex,
      );
    });
    // items.insert(items.length >> 1, _buildMiddleTabItem());

    return BottomAppBar(
      //   shape: widget.notchedShape,
      color: widget.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildMiddleTabItem() {
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.iconSize),
            Text(
              widget.centerItemText,
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required FABBottomAppBarItem item,
    required ValueChanged<int> onPressed,
  }) {
    Color color = _selectedIndex == item.index ? widget.selectedColor : widget.color;
    final icon = SVGImageResource(item.svgResourcePath).getImageWidget(width: widget.iconSize, height: widget.iconSize, color: color);
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(item.index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                item.index == BottomNavItem.ORDER
                    ? ValueListenableBuilder<bool>(
                        valueListenable: InAppNotificationHandler().orderBadgeNotifier(),
                        builder: (context, willShowBadge, child) {
                          return willShowBadge
                              ? bg.Badge(
                                  position: bg.BadgePosition.topEnd(end: -1, top: -1),
                                  badgeStyle: bg.BadgeStyle(
                                    shape: bg.BadgeShape.circle,
                                    badgeColor: AppColors.red,
                                    padding: const EdgeInsets.all(5),
                                    borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                                  ),
                                  child: icon,
                                )
                              : icon;
                        },
                      )
                    : icon,
                Text(
                  item.text,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
