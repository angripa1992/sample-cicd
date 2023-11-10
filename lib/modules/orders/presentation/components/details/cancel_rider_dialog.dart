import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/presentation/bloc/cancel_rider_cubit.dart';
import 'package:klikit/modules/widgets/app_button.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/di.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/order.dart';

void showCancelRiderDialog({
  required BuildContext context,
  required Order order,
  required VoidCallback successCallback,
}) {
  showDialog(
    context: context,
    builder: (dContext) {
      return BlocProvider<CancelRiderCubit>(
        create: (_) => getIt.get<CancelRiderCubit>(),
        child: AlertDialog(
          icon: SvgPicture.asset(
            AppIcons.alert,
            height: AppSize.s24.rh,
            width: AppSize.s24.rw,
          ),
          title: const Text('Switch to manual rider lookup?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to switch to manual rider lookup? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: regularTextStyle(
                  color: AppColors.greyDarker,
                  fontSize: AppFontSize.s15.rSp,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () {
                      Navigator.of(dContext).pop();
                    },
                    text: AppStrings.no.tr(),
                    borderColor: AppColors.black,
                    color: AppColors.white,
                    textColor: AppColors.black,
                  ),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: BlocConsumer<CancelRiderCubit, ResponseState>(
                    builder: (context, state) => LoadingButton(
                      isLoading: state is Loading,
                      onTap: () {
                        context.read<CancelRiderCubit>().cancelRider(order.id);
                      },
                      text: AppStrings.yes.tr(),
                      color: AppColors.red,
                      borderColor: AppColors.red,
                    ),
                    listener: (context, state) {
                      if (state is Failed) {
                        showApiErrorSnackBar(context, state.failure);
                      } else if (state is Success<ActionSuccess>) {
                        Navigator.pop(dContext);
                        showSuccessSnackBar(context, state.data.message ?? '');
                        successCallback();
                      }
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
