import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class NoteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int minLines;

  const NoteTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.minLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.greyLighter,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
        child: TextField(
          controller: controller,
          minLines: minLines,
          maxLines: minLines,
          textInputAction: TextInputAction.go,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: regularTextStyle(
              color: AppColors.greyDarker,
              fontSize: AppFontSize.s14.rSp,
            ),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ),
      ),
    );
  }
}
