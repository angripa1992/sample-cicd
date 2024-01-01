import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
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
          if (title != null) Text(title!, textAlign: TextAlign.center, style: mediumTextStyle(color: AppColors.black, fontSize: AppFontSize.s17.rSp)),
          const Spacer(),
          InkWell(
            child: ImageResourceResolver.closeSVG.getImageWidget(width: 20.rw, height: 20.rh),
            onTap: () {
              _onDismissed(context);
            },
          )
        ],
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s12.rh),
        child: Row(
          children: [
            isSuccess
                ? ImageResourceResolver.successSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh)
                : ImageResourceResolver.infoSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.errorR300),
            10.horizontalSpacer(),
            Text(message, textAlign: TextAlign.start, style: regularTextStyle(fontSize: AppSize.s14.rSp, color: AppColors.neutralB200)),
          ],
        ),
      ),
    );
  }

  void _onDismissed(BuildContext context) {
    if (onDismiss != null) onDismiss!();
    Navigator.pop(context);
  }
}
