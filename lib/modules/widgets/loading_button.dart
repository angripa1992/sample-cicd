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

  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.onTap,
    required this.text,
    this.textColor,
    this.enabled = true,
    this.color,
    this.borderColor,
  }) : super(key: key);

  Color _bgColor() {
    if (!enabled) {
      return AppColors.smokeyGrey;
    } else if (isLoading) {
      return AppColors.white;
    } else {
      return color ?? AppColors.purpleBlue;
    }
  }

  Color _borderColor() {
    if (!enabled) {
      return AppColors.smokeyGrey;
    } else {
      return borderColor ?? AppColors.purpleBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (!enabled || isLoading) ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _bgColor(),
        disabledBackgroundColor:
            isLoading ? AppColors.white : AppColors.smokeyGrey,
        side: BorderSide(
          width: AppSize.s1.rw,
          color: _borderColor(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: AppSize.s12.rh,
              width: AppSize.s12.rw,
              child: CircularProgressIndicator(color: color ?? AppColors.purpleBlue),
            )
          : Text(
              text,
              style: mediumTextStyle(
                color: textColor ?? AppColors.white,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
    );
  }
}
