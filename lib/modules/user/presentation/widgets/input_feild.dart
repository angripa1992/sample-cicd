import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../app/functions.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/fonts.dart';
import '../../../../resources/styles.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool obscureText;

  const InputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.inputType,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getRegularTextStyle(
            fontFamily: AppFonts.ABeeZee,
            color: AppColors.blueViolet,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: inputType,
          cursorColor: AppColors.blueViolet,
          style: getRegularTextStyle(
            fontFamily: AppFonts.ABeeZee,
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueViolet),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueViolet),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueViolet),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.field_required.tr();
            } else if (inputType == TextInputType.emailAddress &&
                !isEmailValid(value)) {
              return AppStrings.enter_valid_email.tr();
            }
            return null;
          },
        ),
      ],
    );
  }
}
