import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

Widget PrintButton(VoidCallback onPrint){
  return SizedBox(
    height: AppSize.s32.rh,
    child: ElevatedButton(
      onPressed: onPrint,
      style: ElevatedButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.symmetric(horizontal: AppSize.s32.rw),
        primary: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s24.rSp), // <-- Radius
        ),
      ),
      child: Text(
        'Print',
        style: getMediumTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
    ),
  );
}