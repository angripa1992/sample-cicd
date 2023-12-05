import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class KTTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? errorText;
  final bool? readOnly;
  final Function? validation;
  final bool? passwordField;
  final AutovalidateMode autovalidateMode;
  final Color? fontColor;
  final Color? hintColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final EdgeInsets? contentPadding;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final Function(String)? onChanged;
  final int? minLines;
  final Color? fillColor;
  final bool? filled;

  const KTTextField(
      {Key? key,
      required this.controller,
      this.hintText,
      this.readOnly,
      this.validation,
      this.passwordField,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.fontColor,
      this.hintColor,
      this.borderColor,
      this.onTap,
      this.textStyle,
      this.suffixIcon,
      this.suffixIconColor,
      this.contentPadding,
      this.textInputType,
      this.textInputAction,
      this.inputFormatters,
      this.maxLines,
      this.onChanged,
      this.minLines,
      this.errorText,
      this.fillColor,
      this.filled})
      : super(key: key);

  @override
  State<KTTextField> createState() => _KTTextFieldState();
}

class _KTTextFieldState extends State<KTTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnly ?? false,
      onTap: widget.onTap,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: widget.textInputType,
      inputFormatters: widget.inputFormatters,
      minLines: widget.minLines,
      maxLines: (widget.passwordField ?? false) ? 1 : widget.maxLines ?? 1,
      validator: (text) {
        if (widget.validation == null) {
          return null;
        } else {
          return widget.validation!(text);
        }
      },
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      style: widget.textStyle ??
          regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
      obscureText: (widget.passwordField ?? false) && _obscurePassword,
      cursorColor: widget.textStyle?.color ?? AppColors.black,
      autovalidateMode: widget.autovalidateMode,
      decoration: InputDecoration(
        filled: widget.filled,
        fillColor: widget.fillColor,
        suffixIcon: (widget.passwordField ?? false)
            ? IconButton(
          onPressed: () {
                  _obscurePassword = !_obscurePassword;
                  if (mounted) {
                    setState(() {});
                  }
                },
                icon: _obscurePassword ? Icon(Icons.visibility_off_outlined, color: AppColors.neutralB600) : Icon(Icons.visibility_outlined, color: AppColors.neutralB600),
              )
            : widget.suffixIcon != null
                ? Icon(widget.suffixIcon, color: widget.suffixIconColor)
                : null,
        errorText: widget.errorText,
        hintText: widget.hintText,
        hintStyle: regularTextStyle(
          color: AppColors.greyDarker,
          fontSize: AppFontSize.s14.rSp,
        ),
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s10.rw,
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          borderSide: BorderSide(color: AppColors.greyDarker),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          borderSide: BorderSide(
            color: AppColors.greyDarker,
            width: widget.readOnly == true ? AppSize.s1.rSp : AppSize.s2.rSp,
          ),
        ),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSize.s8.rSp), borderSide: BorderSide(color: AppColors.red)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8.rSp)),
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
