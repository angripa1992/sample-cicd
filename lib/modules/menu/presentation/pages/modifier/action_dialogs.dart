import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_modifier_cubit.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../orders/data/models/action_success_model.dart';
import '../../../../widgets/loading_button.dart';
import '../../../../widgets/snackbars.dart';

void showEnableModifierDialog({
  required BuildContext context,
  required VoidCallback onSuccess,
  required int brandId,
  required int groupId,
  int? modifierId,
  required int type,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdateModifierCubit>(
        create: (_) => getIt.get<UpdateModifierCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppStrings.enable_confirmation.tr()} ${type == ModifierType.GROUP ? 'modifier group' : 'modifier'}?',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
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
                    child: BlocConsumer<UpdateModifierCubit, ResponseState>(
                      listener: (context, state) {
                        if (state is Success<ActionSuccess>) {
                          Navigator.of(context).pop();
                          showSuccessSnackBar(context,
                              '${type == ModifierType.GROUP ? AppStrings.modifier_group.tr() : AppStrings.modifier.tr()} ${AppStrings.enabled_success.tr()}');
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
                            context.read<UpdateModifierCubit>().updateModifier(
                                  type: type,
                                  enabled: true,
                                  brandId: brandId,
                                  groupId: groupId,
                                  modifierId: modifierId,
                                );
                          },
                          text: AppStrings.enable.tr(),
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
                          AppStrings.discard.tr(),
                          style: mediumTextStyle(
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

void showDisableModifierDialog({
  required BuildContext context,
  required VoidCallback onSuccess,
  required int brandId,
  required int groupId,
  required int type,
  required bool affected,
  int? modifierId,
  String? items,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdateModifierCubit>(
        create: (_) => getIt.get<UpdateModifierCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                affected
                    ? AppStrings.modifier_required_msg.tr()
                    : '${AppStrings.disable_confirmation.tr()} ${type == ModifierType.GROUP ? AppStrings.modifier_group.tr() : AppStrings.modifier.tr()}?',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              affected
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
                      child: ConstrainedBox(
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
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
                child: const Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BlocConsumer<UpdateModifierCubit, ResponseState>(
                      listener: (context, state) {
                        if (state is Success<ActionSuccess>) {
                          Navigator.of(context).pop();
                          showSuccessSnackBar(context,
                              '${type == ModifierType.GROUP ? AppStrings.modifier_group.tr() : AppStrings.modifier.tr() } ${AppStrings.disabled_success.tr()}');
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
                            context.read<UpdateModifierCubit>().updateModifier(
                                  type: type,
                                  enabled: false,
                                  brandId: brandId,
                                  groupId: groupId,
                                  modifierId: modifierId,
                                );
                          },
                          text: AppStrings.disable.tr(),
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
                          AppStrings.discard.tr(),
                          style: mediumTextStyle(
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
