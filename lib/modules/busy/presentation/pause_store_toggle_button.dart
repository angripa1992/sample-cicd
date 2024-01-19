import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_switch.dart';
import 'package:klikit/core/widgets/popups.dart';

import '../../../resources/colors.dart';
import '../../../resources/strings.dart';
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
        showActionablePopup(
          context: context,
          title: isBusy ? AppStrings.offline_title.tr() : AppStrings.online_title.tr(),
          description: isBusy ? AppStrings.offline_message.tr() : AppStrings.online_message.tr(),
          positiveText: isBusy ? AppStrings.go_offline.tr() : AppStrings.go_online.tr(),
          isPositiveAction: !isBusy,
          onAction: () {
            _updatePauseStore(context, isBusy);
          },
        );
      },
    );
  }
}
