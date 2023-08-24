import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';

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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                enable
                    ? 'Are you sure to resume notifications?'
                    : 'Are you sure to pause notifications?',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              SizedBox(height: AppSize.s8.rh),
              Text(
                enable
                    ? 'You will be receiving any notifications of upcoming orders.'
                    : 'You won\'t be receiving any notifications of upcoming orders.',
                style: regularTextStyle(
                  color: AppColors.greyDarker,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              SizedBox(height: AppSize.s16.rh),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: 'Cancel',
                    color: AppColors.white,
                    borderColor: AppColors.black,
                    textColor: AppColors.black,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: AppSize.s16.rw),
                  BlocConsumer<ChangeNotificationSettingCubit, ResponseState>(
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
                        text: enable ? 'Resume' : 'Pause',
                        isLoading: state is Loading,
                        onTap: () {
                          context
                              .read<ChangeNotificationSettingCubit>()
                              .changeNotificationSetting(enable);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
