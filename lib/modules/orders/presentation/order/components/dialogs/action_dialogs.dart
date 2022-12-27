import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/order_action_cubit.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../../resources/colors.dart';
import '../../../../../../../resources/fonts.dart';
import '../../../../../../../resources/styles.dart';
import '../../../../../../../resources/values.dart';
import '../../../../../../app/di.dart';

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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: getMediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s20.rSp,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: const Divider(),
              ),
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
                          verticalPadding: AppSize.s8.rh,
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
                        primary: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                          side: BorderSide(color: AppColors.purpleBlue),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                        child: Text(
                          AppStrings.no.tr(),
                          style: getMediumTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s16.rSp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
