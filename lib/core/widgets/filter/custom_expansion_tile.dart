import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../../resources/styles.dart';

class CustomExpansionTile extends StatefulWidget {
  final Widget child;
  final String title;
  final IconData expandedTrailingIcon;
  final IconData trailingIcon;
  final Color expandedColor;
  final Color color;
  final bool initiallyExpanded;

  const CustomExpansionTile({
    super.key,
    required this.child,
    required this.title,
    required this.expandedTrailingIcon,
    required this.trailingIcon,
    required this.expandedColor,
    required this.color,
    required this.initiallyExpanded,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  late bool _isExpanded;

  @override
  void initState() {
    _isExpanded = widget.initiallyExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        backgroundColor: AppColors.white,
        collapsedBackgroundColor: AppColors.white,
        childrenPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, bottom: AppSize.s4.rh),
        tilePadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, bottom: AppSize.s4.rh),
        title: Text(
          widget.title,
          style: semiBoldTextStyle(
            color: _isExpanded ? widget.expandedColor : widget.color,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        trailing: Icon(
          _isExpanded ? widget.expandedTrailingIcon : widget.trailingIcon,
          color: _isExpanded ? widget.expandedColor : widget.color,
        ),
        children: [
          widget.child,
        ],
        onExpansionChanged: (value) {
          _isExpanded = value;
          setState(() {});
        },
      ),
    );
  }
}
