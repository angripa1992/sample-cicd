import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

class NegativeButton extends StatelessWidget {
  final String? negativeText;

  const NegativeButton({super.key, this.negativeText});

  @override
  Widget build(BuildContext context) {
    return KTButton(
      controller: KTButtonController(label: negativeText ?? AppStrings.cancel.tr()),
      backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
      labelStyle: mediumTextStyle(),
      splashColor: AppColors.greyBright,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
