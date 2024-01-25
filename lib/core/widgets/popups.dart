import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/message_notifier.dart';
import 'package:klikit/modules/widgets/negative_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

void showNotifierDialog(BuildContext context, String message, bool isSuccess, {String? title, Function()? onDismiss}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (childContext) => MessageNotifier(
      title: title,
      message: message,
      isSuccess: isSuccess,
      onDismiss: onDismiss,
    ),
  ).then(
    (value) {
      if (onDismiss != null) {
        onDismiss();
      }
    },
  );
}

void showActionablePopup({
  required BuildContext context,
  Widget? titleIcon,
  String? title,
  String? description,
  String? negativeText,
  String? positiveText,
  bool isPositiveAction = true,
  required VoidCallback onAction,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        title: (titleIcon != null || title != null)
            ? Row(
                children: [
                  titleIcon.setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
                  Visibility(
                    visible: title != null,
                    child: Expanded(
                      child: Text(
                        title!,
                        style: mediumTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s16.rSp,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : null,
        content: description != null ? Text(description, style: regularTextStyle(color: AppColors.black, fontSize: AppFontSize.s14.rSp)) : null,
        actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s24.rh, bottom: AppSize.s16.rh),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: NegativeButton(negativeText: negativeText),
              ),
              SizedBox(width: AppSize.s12.rw),
              Expanded(
                child: KTButton(
                  controller: KTButtonController(label: positiveText ?? AppStrings.ok.tr()),
                  backgroundDecoration: regularRoundedDecoration(backgroundColor: isPositiveAction ? AppColors.successG300 : AppColors.errorR300),
                  labelStyle: mediumTextStyle(color: AppColors.white),
                  progressPrimaryColor: AppColors.white,
                  onTap: () {
                    onAction();
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
