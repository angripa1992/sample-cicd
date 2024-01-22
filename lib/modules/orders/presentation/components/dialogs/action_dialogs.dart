import 'package:docket_design_template/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/entities/order_action_model.dart';
import 'package:klikit/modules/widgets/negative_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../../resources/colors.dart';
import '../../../../../../../resources/values.dart';
import '../../../../../../app/di.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../bloc/order_action_cubit.dart';

Widget prepareActionDecoration(Widget icon, Color backgroundColor) {
  return DecoratedImageView(
    iconWidget: icon,
    padding: EdgeInsets.all(4.rSp),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.all(
        Radius.circular(200.rSp),
      ),
    ),
  );
}

OrderActionModel prepareActionModel(int status) {
  switch (status) {
    case OrderStatus.READY:
      return OrderActionModel(
        prepareActionDecoration(ImageResourceResolver.readyFoodSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.successG300), AppColors.successG50),
        'Are you sure you want to make this order ready? This action cannot be undone.',
        AppStrings.ready.tr(),
        AppColors.successG300,
      );
    case OrderStatus.ACCEPTED:
      return OrderActionModel(
        prepareActionDecoration(ImageResourceResolver.successSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.successG300), AppColors.successG50),
        'Are you sure you want to accept this order? This action cannot be undone.',
        AppStrings.accept.tr(),
        AppColors.successG300,
      );
    case OrderStatus.CANCELLED:
      return OrderActionModel(
        prepareActionDecoration(ImageResourceResolver.closeSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.errorR300), AppColors.errorR50),
        'Are you sure you want to cancel this order? This action cannot be undone.',
        AppStrings.cancel.tr(),
        AppColors.errorR300,
      );
    case OrderStatus.DELIVERED:
      return OrderActionModel(
        prepareActionDecoration(ImageResourceResolver.deliveryCardSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.primaryP300), AppColors.primaryP50),
        'Are you sure you want to deliver this order? This action cannot be undone.',
        AppStrings.deliver.tr(),
        AppColors.primaryP300,
      );
    default:
      return OrderActionModel(
        prepareActionDecoration(ImageResourceResolver.successSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.successG300), AppColors.successG50),
        'Are you sure you want to do this action? This action cannot be undone.',
        AppStrings.yes.tr(),
        AppColors.successG300,
      );
  }
}

void showOrderActionDialog({required BuildContext context, required String title, required int status, required Map<String, dynamic> params, required VoidCallback onSuccess}) {
  final actionModel = prepareActionModel(status);
  final KTButtonController positiveButtonController = KTButtonController(label: actionModel.buttonText);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<OrderActionCubit>(
        create: (_) => getIt.get<OrderActionCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          title: Row(
            children: [
              actionModel.titleIcon.setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
              Text(
                title,
                style: boldTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ],
          ),
          content: Text(actionModel.description, style: regularTextStyle(color: AppColors.black, fontSize: AppFontSize.s14.rSp)),
          actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s12.rh, bottom: AppSize.s16.rh),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: NegativeButton(negativeText: AppStrings.go_back.tr()),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: BlocConsumer<OrderActionCubit, ResponseState>(
                    listener: (context, state) {
                      if (state is Success<ActionSuccess>) {
                        Navigator.of(context).pop();
                        showSuccessSnackBar(context, state.data.message.orEmpty());
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
                        backgroundDecoration: regularRoundedDecoration(backgroundColor: actionModel.buttonBackgroundColor),
                        labelStyle: mediumTextStyle(color: AppColors.white),
                        progressPrimaryColor: AppColors.white,
                        onTap: () {
                          context.read<OrderActionCubit>().updateOrderStatus(params);
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
