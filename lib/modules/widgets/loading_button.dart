import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onTap;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? textSize;
  final double? progressHeight;
  final double? progressWidth;
  final Color? borderColor;
  final Color? loadingBorderColor;
  final Color? bgColor;
  final Color? loadingBgColor;
  final Color? textColor;
  final Color? loaderColor;

  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.onTap,
    required this.text,
    this.verticalPadding,
    this.textSize,
    this.progressHeight,
    this.progressWidth,
    this.horizontalPadding,
    this.borderColor,
    this.bgColor,
    this.loadingBgColor,
    this.loadingBorderColor,
    this.textColor,
    this.loaderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLoading
              ? (loadingBgColor ?? AppColors.lightViolet)
              : (bgColor ?? AppColors.purpleBlue),
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          border: Border.all(
            color: isLoading
                ? (loadingBorderColor ?? AppColors.lightViolet)
                : (borderColor ?? AppColors.purpleBlue),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? AppSize.s12.rh,
              horizontal: horizontalPadding ?? AppSize.s12.rh,
            ),
            child: isLoading
                ? SizedBox(
                    height: progressHeight ?? AppSize.s16.rh,
                    width: progressWidth ?? AppSize.s18.rw,
                    child:
                        CircularProgressIndicator(color: loaderColor ?? AppColors.purpleBlue),
                  )
                : Text(
                    text,
                    style: getBoldTextStyle(
                      color: textColor ?? AppColors.white,
                      fontSize: textSize ?? AppFontSize.s16.rSp,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
