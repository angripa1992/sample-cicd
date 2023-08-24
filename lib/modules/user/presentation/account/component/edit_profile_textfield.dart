import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class EditProfileTextField extends StatelessWidget {
  final TextEditingController editingController;
  final bool enabled;
  final String label;
  final String currentValue;
  final TextInputType? inputType;

  const EditProfileTextField({
    Key? key,
    required this.editingController,
    required this.enabled,
    required this.label,
    required this.currentValue,
    this.inputType,
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
        TextFormField(
          controller: editingController,
          cursorColor: AppColors.black,
          keyboardType: inputType ?? TextInputType.text,
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
          decoration: InputDecoration(
            enabled: enabled,
            isDense: true,
            filled: true,
            fillColor: enabled ? Colors.transparent : AppColors.greyLight,
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s10.rw,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              borderSide: BorderSide(color: AppColors.greyDarker),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              borderSide: BorderSide(color: AppColors.greyDarker),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppSize.s2.rSp),
              ),
              borderSide: const BorderSide(
                width: AppSize.ZERO,
                style: BorderStyle.none,
              ),
            ),
          ),
          validator: (value) {
            if (!enabled) {
              return null;
            } else if (inputType == TextInputType.phone &&
                (value == null ||
                    value.isEmpty ||
                    value.length < 10 ||
                    value.length > 18)) {
              return AppStrings.phone_validation_message.tr();
            } else if (value == null || value.isEmpty) {
              return AppStrings.field_required.tr();
            } else {
              return null;
            }
          },
        )
      ],
    );
  }
}
