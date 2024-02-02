import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

class PositiveButton extends StatelessWidget {
  final String? positiveText;
  final double? buttonRadius;
  final Function() onTap;

  const PositiveButton({super.key, required this.onTap, this.positiveText, this.buttonRadius});

  @override
  Widget build(BuildContext context) {
    return KTButton(
      controller: KTButtonController(label: positiveText ?? AppStrings.apply_filters.tr(), enabled: true),
      backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300, radius: 200.rSp),
      labelStyle: mediumTextStyle(color: AppColors.white),
      horizontalContentPadding: 12.rw,
      onTap: onTap,
    );
  }
}
