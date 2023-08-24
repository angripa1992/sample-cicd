import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool enabled;
  final VoidCallback onTap;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;

  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.onTap,
    required this.text,
    this.textColor,
    this.enabled = true,
    this.color,
    this.borderColor,
    this.icon,
  }) : super(key: key);

  Color _bgColor() {
    if (!enabled) {
      return AppColors.greyDarker;
    } else {
      return color ?? AppColors.primary;
    }
  }

  Color _borderColor() {
    if (!enabled) {
      return AppColors.greyDarker;
    } else {
      return borderColor ?? AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (!enabled || isLoading) ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _bgColor(),
        disabledBackgroundColor:
            isLoading ? AppColors.white : AppColors.greyDarker,
        side: BorderSide(
          width: AppSize.s1.rw,
          color: _borderColor(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s8.rh,
          horizontal: AppSize.s8.rw,
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: AppSize.s12.rh,
              width: AppSize.s12.rw,
              child: CircularProgressIndicator(
                color: borderColor ?? AppColors.primary,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: AppSize.s8.rw),
                    child: Icon(
                      icon,
                      color: textColor ?? AppColors.white,
                    ),
                  ),
                Text(
                  text,
                  style: mediumTextStyle(
                    color: textColor ?? AppColors.white,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ],
            ),
    );
  }
}
