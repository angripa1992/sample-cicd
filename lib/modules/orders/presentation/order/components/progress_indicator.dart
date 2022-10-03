import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

Widget getNewPageProgressIndicator() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
      child: Text(
        'Loading...',
        style: getMediumTextStyle(color: AppColors.purpleBlue),
      ),
    ),
  );
}

Widget getFirstPageProgressIndicator() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
      child: const CircularProgressIndicator(),
    ),
  );
}

Widget getPageErrorIndicator(VoidCallback onRetry) {
  return Center(
    child: Column(
      children: [
        Text(
          'Something Went Wrong',
          style: getMediumTextStyle(
            color: AppColors.blackCow,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(height: AppSize.s8.rh,),
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            primary: AppColors.purpleBlue, // background
            onPrimary: AppColors.white, // foreground
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Try Again'),
              Icon(Icons.refresh),
            ],
          ),
        )
      ],
    ),
  );
}
