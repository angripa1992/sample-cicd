import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/strings.dart';

class CommentView extends StatelessWidget {
  final String comment;

  const CommentView({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: comment.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s8.rh,
          horizontal: AppSize.s16.rw,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Divider(color: AppColors.greyDarker),
            Text(
              AppStrings.order_instruction.tr(),
              style: boldTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
            SizedBox(height: AppSize.s4.rh),
            Text(
              comment,
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
