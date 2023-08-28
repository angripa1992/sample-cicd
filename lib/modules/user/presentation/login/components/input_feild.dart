import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../app/functions.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';

class InputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final Color? labelColor;
  final Color? textColor;
  final Color? borderColor;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool isPasswordField;

  const InputField({
    Key? key,
    required this.label,
    required this.controller,
    required this.inputType,
    required this.isPasswordField,
    this.hintText,
    this.labelColor,
    this.textColor,
    this.borderColor,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool? _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPasswordField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText!,
          keyboardType: widget.inputType,
          cursorColor: widget.textColor ?? AppColors.black,
          style: regularTextStyle(
            color: widget.textColor ?? AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
          decoration: InputDecoration(
            label: Text(widget.label),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelStyle: mediumTextStyle(
              color: widget.labelColor ?? AppColors.black,
              fontSize: AppFontSize.s24.rSp,
            ),
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText!;
                      });
                    },
                    icon: Icon(
                      _obscureText! ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.black,
                    ),
                  )
                : const SizedBox(),
            hintStyle: regularTextStyle(
              color: widget.textColor ?? AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.primaryLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.primaryLight),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.borderColor ?? AppColors.primaryLight),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.field_required.tr();
            } else if (widget.inputType == TextInputType.emailAddress &&
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
