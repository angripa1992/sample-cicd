import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../../resources/colors.dart';
import '../../../../../../../resources/values.dart';
import '../../../../../../app/di.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../widgets/app_button.dart';
import '../../bloc/order_action_cubit.dart';

void showOrderActionDialog({
  required Map<String, dynamic> params,
  required BuildContext context,
  required VoidCallback onSuccess,
  required String title,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<OrderActionCubit>(
        create: (_) => getIt.get<OrderActionCubit>(),
        child: AlertDialog(
          title: Text(
            title,
            style: boldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BlocConsumer<OrderActionCubit, ResponseState>(
                    listener: (context, state) {
                      if (state is Success<ActionSuccess>) {
                        Navigator.of(context).pop();
                        showSuccessSnackBar(
                            context, state.data.message.orEmpty());
                        onSuccess();
                      } else if (state is Failed) {
                        Navigator.of(context).pop();
                        showApiErrorSnackBar(context, state.failure);
                      }
                    },
                    builder: (context, state) {
                      return LoadingButton(
                        isLoading: (state is Loading),
                        onTap: () {
                          context
                              .read<OrderActionCubit>()
                              .updateOrderStatus(params);
                        },
                        text: AppStrings.yes.tr(),
                      );
                    },
                  ),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: AppButton(
                    text: AppStrings.no.tr(),
                    borderColor: AppColors.black,
                    color: AppColors.white,
                    textColor: AppColors.black,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
