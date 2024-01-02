import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_text_field.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final Color? hintColor;
  final Function(String)? onChanged;
  final bool enabled;
  final bool? passwordField;
  final TextInputType? inputType;
  final TextInputAction? textInputAction;
  final Function? validation;

  const LabeledTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.hintText,
    this.hintColor,
    this.onChanged,
    this.enabled = true,
    this.passwordField,
    this.inputType,
    this.textInputAction,
    this.validation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppSize.s14.rSp,
          ),
        ),
        SizedBox(height: AppSize.s12.rh),
        KTTextField(
          controller: controller,
          hintText: hintText,
          hintColor: hintColor,
          passwordField: passwordField,
          onChanged: onChanged,
          textInputType: inputType,
          textInputAction: textInputAction,
          readOnly: !enabled,
          validation: validation,
        )
      ],
    );
  }
}
