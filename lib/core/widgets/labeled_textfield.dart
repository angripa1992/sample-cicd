import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_text_field.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool enabled;
  final TextInputType? inputType;
  final Function? validation;

  const LabeledTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.enabled = true,
    this.inputType,
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
          onChanged: onChanged,
          textInputType: inputType,
          readOnly: !enabled,
          validation: validation,
        )
      ],
    );
  }
}
