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
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;

  const AppButton({
    Key? key,
    this.enable = true,
    required this.onTap,
    required this.text,
    this.icon,
    this.color,
    this.borderColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enable ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            enable ? (color ?? AppColors.purpleBlue) : AppColors.smokeyGrey,
        disabledBackgroundColor: AppColors.smokeyGrey,
        side: BorderSide(
          width: AppSize.s1.rw,
          color: enable
              ? (borderColor ?? AppColors.purpleBlue)
              : AppColors.smokeyGrey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp), // <-- Radius
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: icon != null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
              child: Icon(
                icon,
                color: enable ? (textColor ?? AppColors.white) : AppColors.white,
                size: AppSize.s18.rSp,
              ),
            ),
          ),
          Text(
            text,
            style: mediumTextStyle(
              color: enable ? (textColor ?? AppColors.white) : AppColors.white,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ],
      ),
    );
  }
}
