import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class ActionableTile extends StatelessWidget {
  final String title;
  final BoxDecoration? decoration;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Function()? onTap;

  const ActionableTile({
    Key? key,
    required this.title,
    this.decoration,
    this.prefixWidget,
    this.onTap,
    this.suffixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: decoration?.borderRadius?.resolve(null) ?? BorderRadius.circular(AppSize.s8.rSp),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.rh, horizontal: 12.rw),
        decoration: BoxDecoration(
          color: decoration?.color ?? Colors.transparent,
          border: decoration?.border ?? Border.all(width: 0.5.rSp, color: AppColors.greyDarker),
          borderRadius: decoration?.borderRadius?.resolve(null) ?? BorderRadius.circular(AppSize.s8.rSp),
          boxShadow: decoration?.boxShadow,
        ),
        child: Row(
          children: [
            prefixWidget.setVisibilityWithSpace(direction: Axis.horizontal, endSpace: 12),
            Expanded(
              child: Text(
                title,
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ),
            suffixWidget.setVisibilityWithSpace(direction: Axis.horizontal, startSpace: 12),
          ],
        ),
      ),
    );
  }
}
