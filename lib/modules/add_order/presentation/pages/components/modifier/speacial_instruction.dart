import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../note_text_field.dart';

class SpecialInstructionField extends StatelessWidget {
  final TextEditingController controller;

  const SpecialInstructionField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rSp),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.special_instruction.tr(),
              style: semiBoldTextStyle(
                color: AppColors.neutralB600,
                fontSize: 14.rSp,
              ),
            ),
            SizedBox(height: 8.rh),
            NoteTextField(
              controller: controller,
              hint: AppStrings.add_instruction.tr(),
              minLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
