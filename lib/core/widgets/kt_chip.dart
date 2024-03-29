import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

class KTChip extends StatelessWidget {
  final String text;
  final Widget? textHelperTrailingWidget;
  final double? borderRadius;
  final Color? strokeColor;
  final double? strokeWidth;
  final Color backgroundColor;
  final EdgeInsets? padding;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final TextStyle? textStyle;

  const KTChip({
    Key? key,
    required this.text,
    this.textHelperTrailingWidget,
    this.borderRadius,
    this.strokeColor,
    this.strokeWidth,
    required this.backgroundColor,
    this.padding,
    this.leadingIcon,
    this.trailingIcon,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(AppSize.s4.rSp),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: strokeColor ?? AppColors.neutralB40, width: strokeWidth ?? 1.rSp),
        borderRadius: BorderRadius.circular(borderRadius ?? AppSize.s60.rSp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingIcon != null) (leadingIcon!),
          if (leadingIcon != null) SizedBox(width: AppSize.s4.rw),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
                textHelperTrailingWidget.setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8),
              ],
            ),
          ),
          if (trailingIcon != null) SizedBox(width: AppSize.s4.rw),
          if (trailingIcon != null) (trailingIcon!),
        ],
      ),
    );
  }
}
