import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/pament_method.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/payment_status.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../orders/domain/entities/payment_info.dart';
import '../../../../domain/entities/customer_info.dart';
import '../cart/order_action_button.dart';
import '../cart/step_view.dart';
import 'checkout_appbar.dart';
import 'customer_info.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutData checkoutData;
  final VoidCallback onBack;

  const CheckoutScreen(
      {Key? key, required this.checkoutData, required this.onBack})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _enabledListener = ValueNotifier(false);
  CustomerInfoData? _customerInfo;
  PaymentStatus? _paymentStatus;
  PaymentMethod? _paymentMethod;

  @override
  void dispose() {
    _enabledListener.dispose();
    super.dispose();
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
                      _enabledListener.value = true;
                    },
                  ),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _enabledListener,
            builder: (_,enabled,__){
              return OrderActionButton(
                buttonText: 'Place Order',
                enable: enabled,
                totalPrice: widget.checkoutData.cartBill.totalPrice,
                onProceed: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
