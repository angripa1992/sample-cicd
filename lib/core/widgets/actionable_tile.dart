import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class ActionableTile extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final Widget? titleHelper;
  final String? subtitle;
  final BoxDecoration? decoration;
  final Color? splashColor;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Function()? onTap;

  const ActionableTile({
    Key? key,
    required this.title,
    this.titleStyle,
    this.titleHelper,
    this.subtitle,
    this.decoration,
    this.splashColor,
    this.prefixWidget,
    this.onTap,
    this.suffixWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: decoration?.borderRadius?.resolve(null) ?? BorderRadius.circular(AppSize.s8.rSp),
      splashColor: splashColor,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.rh, horizontal: 12.rw),
        decoration: BoxDecoration(
          color: decoration?.color ?? Colors.transparent,
          border: decoration?.border ?? Border.all(width: 0.5.rSp, color: AppColors.neutralB40),
          borderRadius: decoration?.borderRadius?.resolve(null) ?? BorderRadius.circular(AppSize.s8.rSp),
          boxShadow: decoration?.boxShadow,
        ),
        child: Row(
          children: [
            prefixWidget.setVisibilityWithSpace(direction: Axis.horizontal, endSpace: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: titleStyle ??
                              mediumTextStyle(
                                color: AppColors.black,
                                fontSize: AppFontSize.s16.rSp,
                              ),
                        ),
                      ),
                      titleHelper.setVisibilityWithSpace(startSpace: AppSize.s12, direction: Axis.horizontal)
                    ],
                  ),
                  if (subtitle.isNotNullOrEmpty())
                    Text(
                      subtitle!,
                      style: regularTextStyle(
                        color: AppColors.neutralB500,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                    ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s4),
                ],
              ),
            ),
            suffixWidget.setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s12),
          ],
        ),
      ),
    );
  }
}
