import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class MessageNotifier extends StatelessWidget {
  final String? title;
  final String message;
  final bool isSuccess;
  final Function()? onDismiss;

  const MessageNotifier({
    Key? key,
    this.title,
    required this.message,
    required this.isSuccess,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.rSp),
        ),
      ),
      title: title != null
          ? Text(
              title!,
              textAlign: TextAlign.center,
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s17.rSp,
              ),
            )
          : null,
      content: Padding(
        padding: EdgeInsets.all(AppSize.s12.rSp),
        child: Text(message, textAlign: TextAlign.start, style: regularTextStyle(fontSize: AppSize.s16.rSp)),
      ),
      actionsPadding: EdgeInsets.only(
        left: AppSize.s16.rw,
        right: AppSize.s16.rw,
        bottom: AppSize.s8.rh,
      ),
      actions: [
        KTButton(
          controller: KTButtonController(label: AppStrings.ok.tr()),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: isSuccess ? AppColors.successG600 : AppColors.errorR300),
          labelStyle: mediumTextStyle(color: AppColors.white),
          onTap: () {
            _onDismissed(context);
          },
        )
      ],
    );
  }

  void _onDismissed(BuildContext context) {
    if (onDismiss != null) onDismiss!();
    Navigator.pop(context);
  }
}
