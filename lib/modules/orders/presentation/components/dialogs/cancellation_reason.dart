import 'package:dartz/dartz.dart' as dartz;
import 'package:docket_design_template/utils/extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/error_handler.dart';

import '../../../../../app/constants.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/loading_button.dart';
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
          icon: Icon(
            Icons.warning_amber,
            color: AppColors.redDark,
          ),
          title: Text(
            title,
            style: boldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s18.rSp,
            ),
          ),
          content: Column(
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
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                },
              ),
            ],
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
  State<CancellationReasonDialogContent> createState() =>
      _CancellationReasonDialogContentState();
}

class _CancellationReasonDialogContentState
    extends State<CancellationReasonDialogContent> {
  final _valueNotifier = ValueNotifier<int?>(null);
  final _textController = TextEditingController();
  int? _cancellationReasonId;

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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Are you sure you want to cancel this order? This action cannot be undone.',
            style: regularTextStyle(
              color: AppColors.greyDarker,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(height: AppSize.s16.rh),
          Text(
            'Cancellation Reason',
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
            'Notes',
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
              labelText: 'Enter Description',
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
                child: AppButton(
                  text: 'Dismiss',
                  borderColor: AppColors.greyDarker,
                  color: AppColors.white,
                  textColor: AppColors.black,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: AppSize.s8.rw),
              Expanded(
                child: BlocConsumer<OrderActionCubit, ResponseState>(
                  listener: (context, state) {
                    if (state is Success<ActionSuccess>) {
                      Navigator.of(context).pop();
                      showSuccessSnackBar(
                          context, state.data.message!.orEmpty());
                      widget.successCallback();
                    } else if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    }
                  },
                  builder: (context, state) {
                    return ValueListenableBuilder<int?>(
                      valueListenable: _valueNotifier,
                      builder: (_, value, __) {
                        return LoadingButton(
                          enabled: value != null,
                          isLoading: state is Loading,
                          color: AppColors.redDark,
                          textColor: AppColors.white,
                          borderColor: AppColors.redDark,
                          text: AppStrings.reject.tr(),
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
      ),
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
  State<CancellationReasonSelector> createState() =>
      _CancellationReasonSelectorState();
}

class _CancellationReasonSelectorState
    extends State<CancellationReasonSelector> {
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
          'Select a reason',
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
