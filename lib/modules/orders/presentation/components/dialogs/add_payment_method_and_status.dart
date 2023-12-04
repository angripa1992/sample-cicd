import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../add_order/presentation/pages/components/checkout/pament_method.dart';
import '../../../../add_order/presentation/pages/components/checkout/payment_status.dart';
import '../../../../widgets/loading_button.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/order.dart';
import '../../bloc/update_payment_info_cubit.dart';

void showAddPaymentStatusMethodDialog({
  required BuildContext context,
  required Order order,
  required Function(int, int, int) onSuccess,
  required bool willOnlyUpdatePaymentInfo,
  required String title,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdatePaymentInfoCubit>(
        create: (_) => getIt.get<UpdatePaymentInfoCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: AddPaymentMethodAndStatusView(
            order: order,
            willOnlyUpdatePaymentInfo: willOnlyUpdatePaymentInfo,
            onSuccess: onSuccess,
            title: title,
          ),
        ),
      );
    },
  );
}

class AddPaymentMethodAndStatusView extends StatefulWidget {
  final Order order;
  final Function(int, int, int) onSuccess;
  final bool willOnlyUpdatePaymentInfo;
  final String title;

  const AddPaymentMethodAndStatusView({
    Key? key,
    required this.order,
    required this.onSuccess,
    required this.willOnlyUpdatePaymentInfo,
    required this.title,
  }) : super(key: key);

  @override
  State<AddPaymentMethodAndStatusView> createState() => _AddPaymentMethodAndStatusViewState();
}

class _AddPaymentMethodAndStatusViewState extends State<AddPaymentMethodAndStatusView> {
  static const _status = 'status';
  static const _method = 'method';
  static const _channel = 'channel';
  final _paymentNotifier = ValueNotifier<Map<String, int?>>({
    _status: null,
    _method: null,
    _channel: null,
  });

  @override
  void initState() {
    _paymentNotifier.value = {
      _status: widget.willOnlyUpdatePaymentInfo ? (widget.order.paymentStatus > 0 ? widget.order.paymentStatus : null) : PaymentStatusId.paid,
      _method: widget.order.paymentMethod > 0 ? widget.order.paymentMethod : null,
      _channel: widget.order.paymentChannel > 0 ? widget.order.paymentChannel : null,
    };
    super.initState();
  }

  @override
  void dispose() {
    _paymentNotifier.dispose();
    super.dispose();
  }

  ///TODO need adjusment here
  void _updateStatus() {
    final value = _paymentNotifier.value;
    if (widget.willOnlyUpdatePaymentInfo) {
      context.read<UpdatePaymentInfoCubit>().updatePaymentInfo({
        "id": widget.order.id,
        "payment_method": value[_method],
        "payment_channel_id": value[_channel],
        "payment_status": value[_status],
      });
    } else {
      context.read<UpdatePaymentInfoCubit>().updateOrderStatus({
        "UPDATE_PAYMENT_STATUS": true,
        "id": widget.order.id,
        "payment_method": value[_method],
        "payment_channel_id": value[_channel],
        "payment_status": value[_status],
        "status": OrderStatus.DELIVERED,
      });
    }
  }

  void _onSuccess() {
    final value = _paymentNotifier.value;
    widget.onSuccess(value[_method]!, value[_channel]!, value[_status]!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            )
          ],
        ),
        PaymentMethodView(
          initMethod: widget.order.paymentMethod > 0 ? widget.order.paymentMethod : null,
          initChannel: widget.order.paymentChannel > 0 ? widget.order.paymentChannel : null,
          willShowReqTag: true,
          required: true,
          onChanged: (method, channel) {
            final previousValue = _paymentNotifier.value;
            _paymentNotifier.value = {
              _status: previousValue[_status],
              _method: method,
              _channel: channel,
            };
          },
        ),
        PaymentStatusView(
          initStatus: widget.willOnlyUpdatePaymentInfo ? (widget.order.paymentStatus > 0 ? widget.order.paymentStatus : null) : PaymentStatusId.paid,
          willShowReqTag: true,
          onChanged: (status) {
            final previousValue = _paymentNotifier.value;
            _paymentNotifier.value = {
              _status: status,
              _method: previousValue[_method],
              _channel: previousValue[_channel],
            };
          },
        ),
        ValueListenableBuilder<Map<String, int?>>(
          valueListenable: _paymentNotifier,
          builder: (_, value, __) {
            return BlocConsumer<UpdatePaymentInfoCubit, ResponseState>(
              listener: (context, state) {
                if (state is Success<ActionSuccess>) {
                  showSuccessSnackBar(context, state.data.message ?? '');
                  _onSuccess();
                  Navigator.pop(context);
                } else if (state is Failed) {
                  showApiErrorSnackBar(context, state.failure);
                }
              },
              builder: (context, state) {
                return LoadingButton(
                  isLoading: state is Loading,
                  onTap: _updateStatus,
                  text: AppStrings.proceed.tr(),
                  enabled: value[_status] != null && value[_method] != null,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
