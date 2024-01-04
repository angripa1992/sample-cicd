import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_switch.dart';
import 'package:klikit/core/widgets/popups.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/strings.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../widgets/app_button.dart';
import '../domain/repository/pause_store_repository.dart';

class PauseStoreToggleButton extends StatelessWidget {
  final bool isBusy;
  final bool isBranch;
  final VoidCallback onSuccess;
  final int? brandID;

  const PauseStoreToggleButton({
    Key? key,
    required this.isBusy,
    required this.isBranch,
    required this.onSuccess,
    this.brandID,
  }) : super(key: key);

  void _updatePauseStore(BuildContext context, bool isBusy) async {
    EasyLoading.show();
    final params = {
      'branch_id': SessionManager().branchId(),
      'is_busy': isBusy,
    };
    if (!isBranch && brandID != null) {
      params['brand_id'] = brandID!;
    }
    final response = await getIt.get<PauseStoreRepository>().updatePauseStore(params);
    EasyLoading.dismiss();
    response.fold(
      (failure) {
        showNotifierDialog(context, failure.message, false);
      },
      (successResponse) {
        showNotifierDialog(context, successResponse.message, true);
        onSuccess();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return KTSwitch(
      width: 40.rw,
      height: 20.rh,
      controller: ValueNotifier<bool>(isBusy),
      activeColor: AppColors.errorR300,
      onChanged: (isBusy) {
        _showPauseStoreConfirmDialog(
          context,
          isBusy,
          () {
            _updatePauseStore(context, isBusy);
          },
        );
      },
    );
  }

  void _showPauseStoreConfirmDialog(BuildContext context, bool isBusy, VoidCallback onAction) {
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
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: AppButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: AppStrings.not_now.tr(),
                    borderColor: AppColors.black,
                    textColor: AppColors.black,
                    color: AppColors.white,
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
