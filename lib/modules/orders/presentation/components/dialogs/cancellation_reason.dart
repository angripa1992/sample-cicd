import 'package:dartz/dartz.dart' as dartz;
import 'package:docket_design_template/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/orders/presentation/components/dialogs/action_dialogs.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../../../app/constants.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/snackbars.dart';
import '../../../data/models/action_success_model.dart';
import '../../../domain/entities/cancellation_reason.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/repository/orders_repository.dart';
import '../../bloc/order_action_cubit.dart';

void showCancellationReasonDialog({
  required BuildContext context,
  required String title,
  required Order order,
  required VoidCallback successCallback,
}) {
  showDialog(
    context: context,
    builder: (dContext) {
      return BlocProvider<OrderActionCubit>(
        create: (_) => getIt.get<OrderActionCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          title: Row(
            children: [
              prepareActionDecoration(ImageResourceResolver.closeSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.errorR300), AppColors.errorR50),
              AppSize.s8.horizontalSpacer(),
              Text(
                title,
                style: boldTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s18.rSp,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FutureBuilder<dartz.Either<Failure, List<CancellationReason>>>(
                  future: getIt.get<OrderRepository>().fetchCancellationReason(),
                  builder: (context, snap) {
                    if (snap.hasData && snap.data != null) {
                      return snap.data!.fold(
                        (failure) {
                          return Center(child: Text(failure.message));
                        },
                        (reasons) {
                          return CancellationReasonDialogContent(
                            reasons: reasons,
                            order: order,
                            successCallback: successCallback,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgress(
                          primaryColor: AppColors.primary,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class CancellationReasonDialogContent extends StatefulWidget {
  final Order order;
  final List<CancellationReason> reasons;
  final VoidCallback successCallback;

  const CancellationReasonDialogContent({
    Key? key,
    required this.reasons,
    required this.order,
    required this.successCallback,
  }) : super(key: key);

  @override
  State<CancellationReasonDialogContent> createState() => _CancellationReasonDialogContentState();
}

class _CancellationReasonDialogContentState extends State<CancellationReasonDialogContent> {
  final _valueNotifier = ValueNotifier<int?>(null);
  final _textController = TextEditingController();
  int? _cancellationReasonId;
  final KTButtonController positiveButtonController = KTButtonController(label: AppStrings.reject.tr());

  void _cancelOrder() {
    final params = {
      'status': OrderStatus.CANCELLED,
      'id': widget.order.id,
      "platform": "enterprise",
      "cancellation_reason_id": _cancellationReasonId,
      "cancellation_reason": _textController.text,
    };
    context.read<OrderActionCubit>().updateOrderStatus(params);
  }

  @override
  void dispose() {
    _textController.dispose();
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.cancel_order_alert_msg.tr(),
          style: regularTextStyle(
            color: AppColors.greyDarker,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(height: AppSize.s16.rh),
        Text(
          AppStrings.cancellation_reason.tr(),
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(height: AppSize.s8.rh),
        CancellationReasonSelector(
          reasons: widget.reasons,
          onReasonChanged: (reasonId) {
            _cancellationReasonId = reasonId;
            _valueNotifier.value = _cancellationReasonId;
          },
        ),
        SizedBox(height: AppSize.s16.rh),
        Text(
          AppStrings.note.tr(),
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(height: AppSize.s10.rh),
        TextField(
          controller: _textController,
          cursorColor: AppColors.black,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              borderSide: BorderSide(color: AppColors.greyDarker),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              borderSide: BorderSide(color: AppColors.greyDarker),
            ),
            labelText: AppStrings.enter_description.tr(),
            labelStyle: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
        ),
        SizedBox(height: AppSize.s16.rh),
        Row(
          children: [
            Expanded(
              child: KTButton(
                controller: KTButtonController(label: AppStrings.dismiss.tr()),
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
              child: BlocConsumer<OrderActionCubit, ResponseState>(
                listener: (context, state) {
                  if (state is Success<ActionSuccess>) {
                    Navigator.of(context).pop();
                    showSuccessSnackBar(context, state.data.message!.orEmpty());
                    widget.successCallback();
                  } else if (state is Failed) {
                    showApiErrorSnackBar(context, state.failure);
                  }
                },
                builder: (context, state) {
                  return ValueListenableBuilder<int?>(
                    valueListenable: _valueNotifier,
                    builder: (_, value, __) {
                      positiveButtonController.setLoaded(state is! Loading);

                      return KTButton(
                        controller: positiveButtonController,
                        backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.errorR300),
                        labelStyle: mediumTextStyle(color: AppColors.white),
                        progressPrimaryColor: AppColors.white,
                        onTap: _cancelOrder,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CancellationReasonSelector extends StatefulWidget {
  final List<CancellationReason> reasons;
  final Function(int?) onReasonChanged;

  const CancellationReasonSelector({
    Key? key,
    required this.reasons,
    required this.onReasonChanged,
  }) : super(key: key);

  @override
  State<CancellationReasonSelector> createState() => _CancellationReasonSelectorState();
}

class _CancellationReasonSelectorState extends State<CancellationReasonSelector> {
  int? _value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyDarker),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s8.rSp)),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
      child: DropdownButton<int>(
        value: _value,
        underline: const SizedBox(),
        isExpanded: true,
        hint: Text(
          AppStrings.select_reason.tr(),
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        items: widget.reasons.map((value) {
          return DropdownMenuItem<int>(
            value: value.id,
            child: Text(
              value.title,
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
            widget.onReasonChanged(newValue);
          });
        },
      ),
    );
  }
}
