import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../app/di.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/app_button.dart';
import '../../../../../widgets/loading_button.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../domain/entities/success_response.dart';
import '../../cubit/change_notificcation_setting_cubit.dart';

void showPauseNotificationConfirmationDialog({
  required BuildContext context,
  required bool enable,
  required VoidCallback onSuccess,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<ChangeNotificationSettingCubit>(
        create: (_) => getIt.get<ChangeNotificationSettingCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          title: Text(
            enable ? AppStrings.resume_notification_alert_msg.tr() : AppStrings.pause_notification_alert_msg.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          content: Text(
            enable ? AppStrings.you_will_receive_notification.tr() : AppStrings.you_wont_receive_notification.tr(),
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          actionsPadding: EdgeInsets.only(
            left: AppSize.s16.rw,
            right: AppSize.s16.rw,
            bottom: AppSize.s8.rh,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: AppButton(
                    text: AppStrings.cancel.tr(),
                    color: AppColors.white,
                    borderColor: AppColors.black,
                    textColor: AppColors.black,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: AppSize.s16.rw),
                Expanded(
                  child: BlocConsumer<ChangeNotificationSettingCubit, ResponseState>(
                    listener: (context, state) {
                      if (state is Success<SuccessResponse>) {
                        Navigator.of(context).pop();
                        showSuccessSnackBar(context, state.data.message);
                        onSuccess();
                      } else if (state is Failed) {
                        Navigator.of(context).pop();
                        showApiErrorSnackBar(context, state.failure);
                      }
                    },
                    builder: (context, state) {
                      return LoadingButton(
                        text: enable ? AppStrings.resume.tr() : AppStrings.pause.tr(),
                        isLoading: state is Loading,
                        onTap: () {
                          context.read<ChangeNotificationSettingCubit>().changeNotificationSetting(enable);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
