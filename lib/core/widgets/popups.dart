import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/message_notifier.dart';
import 'package:klikit/modules/orders/presentation/components/dialogs/action_dialogs.dart';
import 'package:klikit/modules/user/presentation/account/cubit/auto_accept_order_cubit.dart';
import 'package:klikit/modules/widgets/negative_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

void showNotifierDialog(BuildContext context, String message, bool isSuccess, {String? title, Function()? onDismiss}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (childContext) => MessageNotifier(
      title: title,
      message: message,
      isSuccess: isSuccess,
      onDismiss: onDismiss,
    ),
  ).then(
    (value) {
      if (onDismiss != null) {
        onDismiss();
      }
    },
  );
}

void showActionablePopup({
  required BuildContext context,
  Widget? titleIcon,
  Widget? content,
  String? title,
  String? description,
  String? negativeText,
  String? positiveText,
  Widget? positiveIcon,
  bool isPositiveAction = true,
  required Function() onAction,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        title: (titleIcon != null || title != null)
            ? Row(
                children: [
                  titleIcon.setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
                  Visibility(
                    visible: title != null,
                    child: Expanded(
                      child: Text(
                        title!,
                        style: mediumTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s16.rSp,
                        ),
                      ),
                    ),
                  )
                ],
              )
            : null,
        content: content ?? (description != null ? Text(description, style: regularTextStyle(color: AppColors.black, fontSize: AppFontSize.s14.rSp)) : null),
        actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s24.rh, bottom: AppSize.s16.rh),
        actions: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: NegativeButton(negativeText: negativeText),
                ),
                SizedBox(width: AppSize.s12.rw),
                Expanded(
                  child: KTButton(
                    controller: KTButtonController(label: positiveText ?? AppStrings.ok.tr()),
                    backgroundDecoration: regularRoundedDecoration(backgroundColor: isPositiveAction ? AppColors.successG300 : AppColors.errorR300),
                    prefixWidget: positiveIcon,
                    labelStyle: mediumTextStyle(color: AppColors.white),
                    progressPrimaryColor: AppColors.white,
                    onTap: () {
                      onAction();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void autoAcceptDialog(BuildContext context, bool enable, {required Function() onSuccess}) {
  final KTButtonController positiveButtonController = KTButtonController(label: AppStrings.okay.tr());

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<AutoAcceptOrderCubit>(
        create: (_) => getIt.get<AutoAcceptOrderCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              prepareActionDecoration(
                ImageResourceResolver.autoAcceptSVG.getImageWidget(color: enable ? AppColors.successG300 : AppColors.errorR300),
                enable ? AppColors.successG50 : AppColors.errorR50,
              ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
              Expanded(
                child: Text(
                  AppStrings.auto_accept.tr(),
                  style: boldTextStyle(
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
          content: Text(
            enable ? AppStrings.enable_auto_accept_message.tr() : AppStrings.disable_auto_accept_message.tr(),
            style: regularTextStyle(color: AppColors.black, fontSize: AppFontSize.s14.rSp),
          ),
          actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s12.rh, bottom: AppSize.s16.rh),
          actions: [
            BlocConsumer<AutoAcceptOrderCubit, AutoAcceptState>(
              listener: (context, state) {
                if (state is ToggleSuccessState) {
                  Navigator.of(context).pop();
                  onSuccess();
                } else if (state is FailedState) {
                  Navigator.of(context).pop();
                  showApiErrorSnackBar(context, state.failure);
                }
              },
              builder: (context, state) {
                positiveButtonController.setLoaded(state is! LoadingState);

                return KTButton(
                  controller: positiveButtonController,
                  backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.neutralB40, strokeColor: AppColors.neutralB40, radius: 8.rSp),
                  labelStyle: mediumTextStyle(),
                  splashColor: AppColors.greyBright,
                  progressPrimaryColor: AppColors.primaryP300,
                  onTap: () {
                    context.read<AutoAcceptOrderCubit>().togglePreference(enable);
                  },
                );
              },
            )
          ],
        ),
      );
    },
  );
}
