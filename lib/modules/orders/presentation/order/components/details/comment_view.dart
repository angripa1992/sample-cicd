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
          horizontal: AppSize.s12.rw,
        ),
        child: Center(
          child: Text(
            '${AppStrings.note.tr()}: $comment',
            style: getBoldTextStyle(
              color: AppColors.blueViolet,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ),
    );
  }
}
