import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../orders/data/models/action_success_model.dart';
import '../../../../widgets/snackbars.dart';
import '../../cubit/update_modifier_enabled_cubit.dart';

void showUpdateModifierEnabledConfirmationDialog({
  required BuildContext context,
  required VoidCallback onSuccess,
  required bool isEnable,
  required int brandId,
  required int branchID,
  required int groupId,
  required int type,
  required int menuVersion,
  required bool affected,
  int? modifierId,
  String? items,
}) {
  final KTButtonController positiveButtonController = KTButtonController(label: isEnable ? AppStrings.enable.tr() : AppStrings.disable.tr());

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdateModifierEnabledCubit>(
        create: (_) => getIt.get<UpdateModifierEnabledCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  (!isEnable && affected)
                      ? AppStrings.modifier_required_msg.tr()
                      : (isEnable
                          ? '${AppStrings.enable_confirmation.tr()} ${type == ModifierType.GROUP ? AppStrings.modifier_group.tr() : AppStrings.modifier.tr()}?'
                          : '${AppStrings.disable_confirmation.tr()} ${type == ModifierType.GROUP ? AppStrings.modifier_group.tr() : AppStrings.modifier.tr()}?'),
                  style: mediumTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
              AppSize.s8.horizontalSpacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ImageResourceResolver.closeSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.neutralB600),
              )
            ],
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
                        color: AppColors.primaryLight,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s12.rh, bottom: AppSize.s16.rh),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: KTButton(
                    controller: KTButtonController(label: AppStrings.discard.tr()),
                    backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
                    labelStyle: mediumTextStyle(),
                    splashColor: AppColors.greyBright,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: BlocConsumer<UpdateModifierEnabledCubit, ResponseState>(
                    listener: (context, state) {
                      if (state is Success<ActionSuccess>) {
                        Navigator.of(context).pop();
                        showSuccessSnackBar(context, state.data.message ?? AppStrings.successful.tr());
                        onSuccess();
                      } else if (state is Failed) {
                        Navigator.of(context).pop();
                        showApiErrorSnackBar(context, state.failure);
                      }
                    },
                    builder: (context, state) {
                      positiveButtonController.setLoaded(state is! Loading);

                      return KTButton(
                        controller: positiveButtonController,
                        backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
                        labelStyle: mediumTextStyle(color: AppColors.white),
                        progressPrimaryColor: AppColors.white,
                        onTap: () {
                          context.read<UpdateModifierEnabledCubit>().updateModifier(
                                menuVersion: menuVersion,
                                type: type,
                                enabled: isEnable,
                                brandId: brandId,
                                branchID: branchID,
                                groupId: groupId,
                                modifierId: modifierId,
                              );
                        },
                      );
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
