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
  final double? textSize;
  final double? progressHeight;
  final double? progressWidth;

  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.onTap,
    required this.text,
    this.verticalPadding,
    this.textSize,
    this.progressHeight,
    this.progressWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
            color: isLoading ? AppColors.lightViolet : AppColors.purpleBlue,
            borderRadius: BorderRadius.circular(AppSize.s8.rSp)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? AppSize.s12.rh,
            ),
            child: isLoading
                ? SizedBox(
                    height: progressHeight ?? AppSize.s16.rh,
                    width: progressWidth ?? AppSize.s18.rw,
                    child:
                        CircularProgressIndicator(color: AppColors.purpleBlue),
                  )
                : Text(
                    text,
                    style: getBoldTextStyle(
                      color: AppColors.white,
                      fontSize: textSize ?? AppFontSize.s16.rSp,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
