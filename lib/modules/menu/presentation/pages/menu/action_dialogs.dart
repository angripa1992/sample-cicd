import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_menu_enabled_cubit.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/widgets/negative_button.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/snackbars.dart';

void showMenuActionDialog({
  required BuildContext context,
  required VoidCallback onSuccess,
  required int menuVersion,
  required int brandId,
  required int branchId,
  required int id,
  required int type,
  required bool enabled,
}) {
  final KTButtonController positiveButtonController = KTButtonController(label: enabled ? AppStrings.enable.tr() : AppStrings.disable.tr());
  String typeName() {
    if (type == MenuType.CATEGORY) {
      return 'category';
    } else if (type == MenuType.SECTION) {
      return 'menu';
    } else {
      return 'item';
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdateMenuEnabledCubit>(
        create: (_) => getIt.get<UpdateMenuEnabledCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('${AppStrings.do_you_want_to.tr()} ${enabled ? 'enable' : 'disable'} this ${typeName()}?',
                    style: mediumTextStyle(color: AppColors.neutralB700, fontSize: AppFontSize.s16.rSp)),
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
          actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s12.rh, bottom: AppSize.s16.rh),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: NegativeButton(negativeText: AppStrings.discard.tr()),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: BlocConsumer<UpdateMenuEnabledCubit, ResponseState>(
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
                          context.read<UpdateMenuEnabledCubit>().updateMenu(
                                menuVersion: menuVersion,
                                brandId: brandId,
                                branchId: branchId,
                                id: id,
                                enabled: enabled,
                                type: type,
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
