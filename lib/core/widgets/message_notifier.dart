import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
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
      title: Row(
        children: [
          DecoratedImageView(
            iconWidget: isSuccess
                ? ImageResourceResolver.successSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh)
                : ImageResourceResolver.infoSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.errorR300),
            padding: EdgeInsets.all(4.rSp),
            decoration: BoxDecoration(
              color: isSuccess ? AppColors.successG50 : AppColors.errorR50,
              borderRadius: BorderRadius.all(
                Radius.circular(200.rSp),
              ),
            ),
          ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
          Text(title ?? (isSuccess ? 'Success!' : 'Error!'), textAlign: TextAlign.start, style: semiBoldTextStyle(color: AppColors.neutralB700, fontSize: AppFontSize.s18.rSp)),
          const Spacer(),
          InkWell(
            child: ImageResourceResolver.closeSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh),
            onTap: () {
              _onDismissed(context);
            },
          ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8)
        ],
      ),
      content: Text(message, textAlign: TextAlign.start, style: regularTextStyle(fontSize: AppSize.s14.rSp, color: AppColors.neutralB200)),
      actionsPadding: EdgeInsets.all(AppSize.s16.rSp),
      actions: [
        KTButton(
          controller: KTButtonController(label: 'Okay'),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.neutralB40),
          labelStyle: mediumTextStyle(color: AppColors.neutralB700),
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
