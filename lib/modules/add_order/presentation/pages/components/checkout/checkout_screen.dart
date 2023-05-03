import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/add_order/data/models/placed_order_response.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/pament_method.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/payment_status.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../orders/domain/entities/payment_info.dart';
import '../../../../domain/entities/customer_info.dart';
import '../../../cubit/place_order_cubit.dart';
import '../cart/order_action_button.dart';
import '../cart/step_view.dart';
import 'checkout_appbar.dart';
import 'customer_info.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutData checkoutData;
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const CheckoutScreen(
      {Key? key,
      required this.checkoutData,
      required this.onBack,
      required this.onSuccess})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CustomerInfoData? _customerInfo;
  PaymentStatus? _paymentStatus;
  PaymentMethod? _paymentMethod;

  void _placeOrder() {
    context.read<PlaceOrderCubit>().placeOrder(
          checkoutData: widget.checkoutData,
          paymentStatus: _paymentStatus?.id ?? PaymentStatusId.pending,
          paymentMethod: _paymentMethod?.id,
          info: _customerInfo,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CheckoutAppBar(onBack: widget.onBack),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s10.rw,
                      vertical: AppSize.s16.rh,
                    ),
                    child: const StepView(
                      stepPosition: StepPosition.checkout,
                    ),
                  ),
                  CustomerInfo(
                    onCustomerInfoSave: (customerInfoData) {
                      _customerInfo = customerInfoData;
                    },
                  ),
                  PaymentMethodView(
                    onChanged: (paymentMethod) {
                      _paymentMethod = paymentMethod;
                    },
                  ),
                  PaymentStatusView(
                    onChanged: (paymentStatus) {
                      _paymentStatus = paymentStatus;
                    },
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<PlaceOrderCubit, ResponseState>(
            listener: (context, state) {
              if (state is Success<PlacedOrderResponse>) {
                CartManager().clear();
                widget.onSuccess();
              }
            },
            builder: (context, state) {
              return OrderActionButton(
                buttonText: 'Place Order',
                enable: state is Loading ? false : true,
                totalPrice: widget.checkoutData.cartBill.totalPrice,
                onProceed: _placeOrder,
                loading: state is Loading,
              );
            },
          ),
        ],
      ),
    );
  }
}
