import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class ApplyFilterButton extends StatelessWidget {
  final Function() applyFilter;

  const ApplyFilterButton({super.key, required this.applyFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(AppSize.s16.rSp),
      child: KTButton(
        controller: KTButtonController(label: AppStrings.apply_filters.tr(), enabled: true),
        backgroundDecoration: BoxDecoration(
          color: AppColors.primaryP300,
          borderRadius: BorderRadius.circular(8.rSp),
        ),
        labelStyle: mediumTextStyle(color: AppColors.white, fontSize: 14.rSp),
        verticalContentPadding: 12.rh,
        onTap: applyFilter,
      ),
    );
  }
}
