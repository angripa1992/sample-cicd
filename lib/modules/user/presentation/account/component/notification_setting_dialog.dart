import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../app/di.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/success_response.dart';
import '../cubit/change_notificcation_setting_cubit.dart';

void showPauseNotificationConfirmationDialog({
  required BuildContext context,
  required bool enable,
  required VoidCallback onSuccess,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final positiveButtonController = KTButtonController(label: enable ? AppStrings.resume.tr() : AppStrings.pause.tr());
      final negativeButtonController = KTButtonController(label: AppStrings.cancel.tr());

      return BlocProvider<ChangeNotificationSettingCubit>(
        create: (_) => getIt.get<ChangeNotificationSettingCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          title: Row(
            children: [
              ImageResourceResolver.notificationAlertSVG
                  .getImageWidget(
                    width: 20.rw,
                    height: 20.rh,
                    color: enable ? AppColors.successG300 : AppColors.errorR300,
                  )
                  .setVisibilityWithSpace(direction: Axis.horizontal, endSpace: 8.rw),
              Expanded(
                child: Text(
                  enable ? AppStrings.resume_notification_alert_msg.tr() : AppStrings.pause_notification_alert_msg.tr(),
                  style: mediumTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              )
            ],
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
            top: AppSize.s24.rh,
            bottom: AppSize.s16.rh,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: KTButton(
                    controller: negativeButtonController,
                    backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
                    labelStyle: mediumTextStyle(),
                    splashColor: AppColors.greyBright,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: AppSize.s12.rw),
                Expanded(
                  child: BlocConsumer<ChangeNotificationSettingCubit, ResponseState>(
                    listener: (context, state) {
                      positiveButtonController.setLoaded(state is! Loading);

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
                      return KTButton(
                        controller: positiveButtonController,
                        backgroundDecoration: regularRoundedDecoration(backgroundColor: enable ? AppColors.successG300 : AppColors.errorR300),
                        labelStyle: mediumTextStyle(color: AppColors.white),
                        progressPrimaryColor: AppColors.white,
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
