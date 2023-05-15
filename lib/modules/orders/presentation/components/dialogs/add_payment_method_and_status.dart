import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../../app/di.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../add_order/presentation/pages/components/checkout/pament_method.dart';
import '../../../../add_order/presentation/pages/components/checkout/payment_status.dart';
import '../../../../widgets/loading_button.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/order.dart';
import '../../bloc/order_action_cubit.dart';
import '../../bloc/update_payment_info_cubit.dart';

void showAddPaymentStatusMethodDialog({
  required BuildContext context,
  required Order order,
  required VoidCallback onSuccess,
}) {
  showDialog(
    context: context,
    //  barrierDismissible: false,
    builder: (context) {
      return BlocProvider<UpdatePaymentInfoCubit>(
        create: (_) => getIt.get<UpdatePaymentInfoCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
          content: AddPaymentMethodAndStatusView(order: order, onSuccess: onSuccess),
        ),
      );
    },
  );
}

class AddPaymentMethodAndStatusView extends StatefulWidget {
  final Order order;
  final VoidCallback onSuccess;
  const AddPaymentMethodAndStatusView({Key? key, required this.order, required this.onSuccess})
      : super(key: key);

  @override
  State<AddPaymentMethodAndStatusView> createState() =>
      _AddPaymentMethodAndStatusViewState();
}

class _AddPaymentMethodAndStatusViewState
    extends State<AddPaymentMethodAndStatusView> {
  static const _status = 'status';
  static const _method = 'method';
  final _statusAndMethodNotifier =
      ValueNotifier<Map<String, int?>>({_status: null, _method: null});

  @override
  void initState() {
    _statusAndMethodNotifier.value = {
      _status: PaymentStatusId.paid,
      _method:
          widget.order.paymentMethod > 0 ? widget.order.paymentMethod : null,
    };
    super.initState();
  }

  @override
  void dispose() {
    _statusAndMethodNotifier.dispose();
    super.dispose();
  }

  void _updateStatus() {
    final value = _statusAndMethodNotifier.value;
    context.read<UpdatePaymentInfoCubit>().updateOrderStatus({
      "UPDATE_PAYMENT_STATUS": true,
      "id": widget.order.id,
      "payment_method": value[_method],
      "payment_status": value[_status],
      "status": OrderStatus.DELIVERED,
    });
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
                'Select payment method and status',
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
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
        PaymentStatusView(
          initStatus: PaymentStatusId.paid,
          willShowReqTag: false,
          onChanged: (status) {
            final previousValue = _statusAndMethodNotifier.value;
            _statusAndMethodNotifier.value = {
              _status: status.id,
              _method: previousValue[_method],
            };
          },
        ),
        PaymentMethodView(
          initMethod: widget.order.paymentMethod > 0
              ? widget.order.paymentMethod
              : null,
          willShowReqTag: false,
          onChanged: (method) {
            final previousValue = _statusAndMethodNotifier.value;
            _statusAndMethodNotifier.value = {
              _status: previousValue[_status],
              _method: method?.id,
            };
          },
        ),
        ValueListenableBuilder<Map<String, int?>>(
          valueListenable: _statusAndMethodNotifier,
          builder: (_, value, __) {
            return BlocConsumer<UpdatePaymentInfoCubit, ResponseState>(
              listener: (context,state){
                if(state is Success<ActionSuccess>){
                  showSuccessSnackBar(context,state.data.message ?? '');
                  widget.onSuccess();
                  Navigator.pop(context);
                }else if(state is Failed){
                  showApiErrorSnackBar(context, state.failure);
                }
              },
              builder: (context, state) {
                return LoadingButton(
                  isLoading: state is Loading,
                  onTap: _updateStatus,
                  text: 'Proceed',
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
