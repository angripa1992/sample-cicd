import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/strings.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../widgets/app_button.dart';

class PauseStoreToggleButton extends StatefulWidget {
  final bool isBusy;
  final bool isBranch;
  final double scale;
  final int? brandID;

  const PauseStoreToggleButton({
    Key? key,
    required this.isBusy,
    required this.isBranch,
    this.scale = 0.75,
    this.brandID,
  }) : super(key: key);

  @override
  State<PauseStoreToggleButton> createState() => _PauseStoreToggleButtonState();
}

class _PauseStoreToggleButtonState extends State<PauseStoreToggleButton> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: CupertinoSwitch(
        onChanged: (isBusy) {
          _showPauseStoreConfirmDialog(
            isBusy,
            () {},
          );
        },
        value: widget.isBusy,
        activeColor: AppColors.black,
        trackColor: AppColors.primary,
      ),
    );
  }

  void _showPauseStoreConfirmDialog(bool isBusy, VoidCallback onAction) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          title: Text(
            isBusy ? AppStrings.offline_title.tr() : AppStrings.online_title.tr(),
            textAlign: TextAlign.center,
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s17.rSp,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isBusy ? AppStrings.offline_message.tr() : AppStrings.online_message.tr(),
                textAlign: TextAlign.center,
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ],
          ),
          actions: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppButton(
                      onTap: () {},
                      text: isBusy ? AppStrings.go_offline.tr() : AppStrings.go_online.tr(),
                      color: isBusy ? AppColors.redDark : AppColors.green,
                      borderColor: isBusy ? AppColors.redDark : AppColors.green,
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          AppStrings.not_now.tr(),
                          style: mediumTextStyle(
                            color: AppColors.primary,
                            fontSize: AppFontSize.s16.rSp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
