import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../note_text_field.dart';

class SpecialInstructionField extends StatelessWidget {
  final TextEditingController controller;
  const SpecialInstructionField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSize.s10.rw,
        vertical: AppSize.s8.rh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s10.rw,
          vertical: AppSize.s16.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Instruction',
              style: getMediumTextStyle(
                color: AppColors.balticSea,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            SizedBox(height: AppSize.s8.rh),
            NoteTextField(
              controller: controller,
              hint: 'Add Instruction',
              minLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}