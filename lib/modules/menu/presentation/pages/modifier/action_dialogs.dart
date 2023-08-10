import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_modifier_enabled_cubit.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../orders/data/models/action_success_model.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/loading_button.dart';
import '../../../../widgets/snackbars.dart';

void showUpdateModifierEnabledConfirmationDialog({
  required BuildContext context,
  required VoidCallback onSuccess,
  required bool isEnable,
  required int brandId,
  required int groupId,
  required int type,
  required int menuVersion,
  required bool affected,
  int? modifierId,
  String? items,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdateModifierEnabledCubit>(
        create: (_) => getIt.get<UpdateModifierEnabledCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          icon: Icon(
            Icons.warning_amber_rounded,
            color: AppColors.purpleBlue,
          ),
          title: Text(
            (!isEnable && affected)
                ? AppStrings.modifier_required_msg.tr()
                : (isEnable
                    ? '${AppStrings.enable_confirmation.tr()} ${type == ModifierType.GROUP ? 'modifier group' : 'modifier'}?'
                    : '${AppStrings.disable_confirmation.tr()} ${type == ModifierType.GROUP ? AppStrings.modifier_group.tr() : AppStrings.modifier.tr()}?'),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          content: (!isEnable && affected)
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: AppSize.s250.rh,
                    minHeight: AppSize.s24.rh,
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      items!,
                      style: mediumTextStyle(
                        color: AppColors.blueViolet,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:
                      BlocConsumer<UpdateModifierEnabledCubit, ResponseState>(
                    listener: (context, state) {
                      if (state is Success<ActionSuccess>) {
                        Navigator.of(context).pop();
                        showSuccessSnackBar(
                          context,
                          state.data.message ?? AppStrings.successful.tr(),
                        );
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
                              .read<UpdateModifierEnabledCubit>()
                              .updateModifier(
                                menuVersion: menuVersion,
                                type: type,
                                enabled: isEnable,
                                brandId: brandId,
                                groupId: groupId,
                                modifierId: modifierId,
                              );
                        },
                        text: isEnable
                            ? AppStrings.enable.tr()
                            : AppStrings.disable.tr(),
                      );
                    },
                  ),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: AppButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    text: AppStrings.discard.tr(),
                    color: AppColors.white,
                    borderColor: AppColors.black,
                    textColor: AppColors.black,
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
