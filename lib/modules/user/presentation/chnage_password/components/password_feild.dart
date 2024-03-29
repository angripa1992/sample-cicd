import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class PasswordField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController newPasswordController;
  final TextEditingController editingController;
  final PasswordFieldType type;

  const PasswordField({
    Key? key,
    required this.label,
    required this.hint,
    required this.editingController,
    required this.type,
    required this.newPasswordController,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  String newPassword = '';
  bool _obscureText = true;

  @override
  void initState() {
    widget.newPasswordController.addListener(() {
      newPassword = widget.newPasswordController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: regularTextStyle(
            color: AppColors.greyDarker,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(height: AppSize.s12.rh),
        TextFormField(
          obscureText: _obscureText,
          controller: widget.editingController,
          cursorColor: AppColors.greyDarker,
          style: regularTextStyle(
            color: AppColors.greyDarker,
            fontSize: AppFontSize.s14.rSp,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.greyDarker,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyDarker),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyDarker),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.greyDarker),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSize.s12.rw,
              vertical: AppSize.ZERO,
            ),
            hintText: widget.hint,
            hintStyle: regularTextStyle(
              color: AppColors.greyDarker,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          validator: (value) {
            if (widget.type == PasswordFieldType.CURRENT) {
              if (value == null || value.isEmpty) {
                return AppStrings.current_password_required.tr();
              }
            } else if (widget.type == PasswordFieldType.NEW) {
              if (value == null || value.isEmpty) {
                return AppStrings.please_enter_new_password.tr();
              }
            } else {
              if (value == null || value.isEmpty) {
                return AppStrings.please_enter_password_again.tr();
              } else if (value != newPassword) {
                return AppStrings.new_and_confirm_not_match.tr();
              }
            }
            return null;
          },
        )
      ],
    );
  }
}
