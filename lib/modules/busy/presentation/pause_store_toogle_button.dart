import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/snackbars.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/strings.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../widgets/app_button.dart';
import '../domain/repository/pause_store_repository.dart';

class PauseStoreToggleButton extends StatefulWidget {
  final bool isBusy;
  final bool isBranch;
  final double scale;
  final VoidCallback onSuccess;
  final int? brandID;

  const PauseStoreToggleButton({
    Key? key,
    required this.isBusy,
    required this.isBranch,
    required this.onSuccess,
    this.scale = 0.75,
    this.brandID,
  }) : super(key: key);

  @override
  State<PauseStoreToggleButton> createState() => _PauseStoreToggleButtonState();
}

class _PauseStoreToggleButtonState extends State<PauseStoreToggleButton> {
  void _updatePauseStore(bool isBusy) async {
    final params = {
      'branch_id': SessionManager().branchId(),
      'is_busy': isBusy,
    };
    if (!widget.isBranch && widget.brandID != null) {
      params['brand_id'] = widget.brandID!;
    }
    final response = await getIt.get<PauseStoreRepository>().updatePauseStore(params);
    response.fold(
      (failure) {
        showApiErrorSnackBar(context, failure);
      },
      (successResponse) {
        showSuccessSnackBar(context, successResponse.message);
        widget.onSuccess();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale,
      child: CupertinoSwitch(
        onChanged: (isBusy) {
          _showPauseStoreConfirmDialog(
            isBusy,
            () {
              _updatePauseStore(isBusy);
            },
          );
        },
        value: widget.isBusy,
        activeColor: AppColors.greyDarker,
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
          actionsPadding: EdgeInsets.only(
            left: AppSize.s16.rw,
            right: AppSize.s16.rw,
            bottom: AppSize.s8.rh,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      onAction();
                    },
                    text: isBusy ? AppStrings.go_offline.tr() : AppStrings.go_online.tr(),
                    color: isBusy ? AppColors.redDark : AppColors.green,
                    borderColor: isBusy ? AppColors.redDark : AppColors.green,
                  ),
                ),
                Expanded(
                  child: AppButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: AppStrings.not_now.tr(),
                    borderColor: AppColors.black,
                    textColor: AppColors.black,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
