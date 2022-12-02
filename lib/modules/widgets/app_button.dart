import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool enable;
  final VoidCallback onTap;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? textSize;
  final double? borderRadius;
  final Color? enableBorderColor;
  final Color? disableBorderColor;
  final Color? enableColor;
  final Color? disableColor;
  final Color? enableTextColor;
  final Color? disableTextColor;
  final IconData? icon;

  const AppButton({
    Key? key,
    required this.enable,
    required this.onTap,
    required this.text,
    this.verticalPadding,
    this.textSize,
    this.horizontalPadding,
    this.enableBorderColor,
    this.enableColor,
    this.disableColor,
    this.disableBorderColor,
    this.enableTextColor,
    this.disableTextColor,
    this.borderRadius,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enable ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: enable
              ? (enableColor ?? AppColors.purpleBlue)
              : (disableColor ?? AppColors.lightGrey),
          borderRadius: BorderRadius.circular(borderRadius ?? AppSize.s8.rSp),
          border: Border.all(
            color: enable
                ? (enableBorderColor ?? AppColors.purpleBlue)
                : (disableBorderColor ?? AppColors.lightGrey),
          ),
        ),
        child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? AppSize.s12.rh,
                horizontal: horizontalPadding ?? AppSize.s12.rh,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: icon != null,
                    child: Icon(
                      icon,
                      color: enable
                          ? (enableTextColor ?? AppColors.white)
                          : (disableTextColor ?? AppColors.white),
                    ),
                  ),
                  Text(
                    text,
                    style: getMediumTextStyle(
                      color: enable
                          ? (enableTextColor ?? AppColors.white)
                          : (disableTextColor ?? AppColors.white),
                      fontSize: textSize ?? AppFontSize.s16.rSp,
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
