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

  const LoadingButton({
    Key? key,
    required this.isLoading,
    required this.onTap,
    required this.text,
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
            padding: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
            child: isLoading
                ? SizedBox(
                    height: AppSize.s16.rh,
                    width: AppSize.s18.rw,
                    child:
                        CircularProgressIndicator(color: AppColors.purpleBlue),
                  )
                : Text(
                    text,
                    style: getRegularTextStyle(
                      fontFamily: AppFonts.Abel,
                      color: AppColors.white,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
