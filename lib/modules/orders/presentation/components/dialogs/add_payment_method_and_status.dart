import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/qris/qris_payment_page.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/resources/decorations.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../add_order/presentation/pages/components/pament_method.dart';
import '../../../../add_order/presentation/pages/components/payment_status.dart';
import '../../../../widgets/snackbars.dart';
import '../../../data/models/qris_payment_success_response.dart';
import '../../../domain/entities/order.dart';
import '../../bloc/update_payment_info_cubit.dart';

void showAddPaymentStatusMethodDialog({
  required BuildContext context,
  required Order order,
  required Function(int, int, int) onSuccess,
  required bool isWebShopPostPayment,
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
            isWebShopPostPayment: isWebShopPostPayment,
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
  final bool isWebShopPostPayment;
  final String title;

  const AddPaymentMethodAndStatusView({
    Key? key,
    required this.order,
    required this.onSuccess,
    required this.isWebShopPostPayment,
    required this.title,
  }) : super(key: key);

  @override
  State<AddPaymentMethodAndStatusView> createState() => _AddPaymentMethodAndStatusViewState();
}

class _AddPaymentMethodAndStatusViewState extends State<AddPaymentMethodAndStatusView> {
  static const _status = 'status';
  static const _method = 'method';
  static const _channel = 'channel';
  final _paymentNotifier = ValueNotifier<Map<String, int?>>({_status: null, _method: null, _channel: null});
  final KTButtonController positiveButtonController = KTButtonController(label: AppStrings.proceed.tr());

  @override
  void initState() {
    _paymentNotifier.value = {
      _status: widget.order.paymentStatus > 0 ? widget.order.paymentStatus : PaymentStatusId.paid,
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

  void _updateStatus() {
    final value = _paymentNotifier.value;
    final paymentMethod = value[_method];
    final paymentChanel = value[_channel];
    final paymentStatus = value[_status];
    final orderID = widget.order.id;
    context.read<UpdatePaymentInfoCubit>().updatePaymentStatus(
          isWebShopPostPayment: widget.isWebShopPostPayment,
          orderID: orderID,
          paymentMethod: paymentMethod!,
          paymentStatus: paymentStatus!,
          paymentChanel: paymentChanel!,
        );
  }

  void _onSuccess() {
    final value = _paymentNotifier.value;
    widget.onSuccess(value[_method]!, value[_channel]!, value[_status]!);
  }

  bool _isButtonEnabled(Map<String, int?> value) {
    if (widget.isWebShopPostPayment) {
      return value[_status] != null && value[_method] != null;
    } else {
      return value[_method] != null;
    }
  }

  void _navigateToQrisPaymentPage(QrisUpdatePaymentResponse response) {
    if (response.checkoutLink != null) {
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return QrisPaymentPage(
          paymentLink: response.checkoutLink!,
          orderID: widget.order.id,
          paymentState: PaymentState.POST_PAYMENT,
        );
      }));
    }
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
        Visibility(
          visible: widget.isWebShopPostPayment,
          child: PaymentStatusView(
            initStatus: widget.isWebShopPostPayment ? (widget.order.paymentStatus > 0 ? widget.order.paymentStatus : null) : PaymentStatusId.paid,
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
                } else if (state is Success<QrisUpdatePaymentResponse>) {
                  _navigateToQrisPaymentPage(state.data);
                } else if (state is Failed) {
                  Navigator.of(context).pop();
                  showApiErrorSnackBar(context, state.failure);
                }
              },
              builder: (context, state) {
                positiveButtonController.setLoaded(state is! Loading);
                positiveButtonController.setEnabled(_isButtonEnabled(value));

                return KTButton(
                  controller: positiveButtonController,
                  backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
                  labelStyle: mediumTextStyle(color: AppColors.white),
                  progressPrimaryColor: AppColors.white,
                  onTap: _updateStatus,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
