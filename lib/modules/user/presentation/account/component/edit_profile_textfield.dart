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
          style: getRegularTextStyle(
            color: AppColors.purpleBlue,
            fontSize: AppSize.s14.rSp,
          ),
        ),
        SizedBox(height: AppSize.s12.rh),
        TextFormField(
          controller: editingController,
          cursorColor: AppColors.black,
          keyboardType: inputType ?? TextInputType.text,
          style: getRegularTextStyle(
            fontFamily: AppFonts.ABeeZee,
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
          decoration: InputDecoration(
            enabled: enabled,
            isDense: true,
            filled: true,
            fillColor: enabled ? AppColors.blueChalk : AppColors.lightGrey,
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s10.rw,
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
            if(!enabled){
              return null;
            }else if (value == null || value.isEmpty) {
              return AppStrings.field_required.tr();
            }else if(value == currentValue){
              return AppStrings.same_value_validation_message.tr();
            }else{
              return null;
            }
          },
        )
      ],
    );
  }
}
