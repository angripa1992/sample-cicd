import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_menu_enabled_cubit.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/loading_button.dart';
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
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdateMenuEnabledCubit>(
        create: (_) => getIt.get<UpdateMenuEnabledCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppStrings.do_you_want_to.tr()} ${enabled ? 'enable' : 'disable'} this ${type == MenuType.SECTION ? 'entire menu' : 'category'}?',
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
                        return LoadingButton(
                          isLoading: (state is Loading),
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
                          text: enabled ? AppStrings.enable.tr() : AppStrings.disable.tr(),
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
                        backgroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                          side: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                        child: Text(
                          AppStrings.discard.tr(),
                          style: mediumTextStyle(
                            color: AppColors.primary,
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
