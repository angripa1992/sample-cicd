import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/data/models/placed_order_response.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/pament_method.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/qris/qris_payment_page.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../app/di.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../utils/order_entity_provider.dart';
import '../cart/order_action_button.dart';
import 'checkout_actions_buttons.dart';
import 'customer_info.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutData checkoutData;
  final bool willUpdateOrder;

  const CheckoutScreen({
    Key? key,
    required this.checkoutData,
    required this.willUpdateOrder,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  CustomerInfo? _customerInfo;
  int? _paymentMethod;
  int? _paymentChannel;
  late ValueNotifier<int?> _paymentChanelNotifier;

  @override
  void initState() {
    final paymentInfo = CartManager().paymentInfo;
    if (paymentInfo != null) {
      _paymentMethod = paymentInfo.paymentMethod;
      _paymentChannel = paymentInfo.paymentChannel;
    }
    _customerInfo = CartManager().customerInfo;
    _paymentChanelNotifier = ValueNotifier(_paymentChannel);
    super.initState();
  }

  int _paymentStatus(CheckoutState checkoutState) {
    late int paymentStatus;
    if (widget.willUpdateOrder) {
      paymentStatus = CartManager().paymentInfo?.paymentStatus ?? PaymentStatusId.pending;
    } else if (checkoutState == CheckoutState.PAY_NOW) {
      paymentStatus = PaymentStatusId.paid;
    } else {
      paymentStatus = PaymentStatusId.pending;
    }
    return paymentStatus;
  }

  void _placeOrder(CheckoutState checkoutState) async {
    if (checkoutState == CheckoutState.PAY_NOW && (_paymentMethod == null || _paymentChannel == null)) {
      showErrorSnackBar(context, 'Please select payment method');
      return;
    }
    EasyLoading.show();
    final body = await OrderEntityProvider().placeOrderRequestData(
      checkoutData: widget.checkoutData,
      paymentStatus: _paymentStatus(checkoutState),
      paymentMethod: _paymentMethod,
      paymentChannel: _paymentChannel,
      info: _customerInfo,
    );
    final response = await getIt.get<AddOrderRepository>().placeOrder(body: body);
    EasyLoading.dismiss();
    response.fold(
      (failure) => showApiErrorSnackBar(context, failure),
      (successResponse) => _handlePlacedOrderResponse(checkoutState, successResponse),
    );
  }

  void _handlePlacedOrderResponse(CheckoutState checkoutState, PlacedOrderResponse response) {
    if (checkoutState == CheckoutState.PAY_NOW && response.checkoutLink != null) {
      _payThroughQrisNow(response);
      return;
    }
    showSuccessSnackBar(context, response.message ?? '');
    if (widget.willUpdateOrder) {
      CartManager().clearAndNavigateToOrderScreen(context);
    } else {
      CartManager().clearAndNavigateToAddOrderScreen(context);
    }
  }

  void _payThroughQrisNow(PlacedOrderResponse response) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => QrisPaymentPage(
        paymentLink: response.checkoutLink!,
        orderID: response.orderId!,
        paymentState: PaymentState.PRE_PAYMENT,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.checkout.tr())),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: AppSize.s8.rh),
                    child: CustomerInfoView(
                      initInfo: _customerInfo,
                      onCustomerInfoSave: (customerInfoData) {
                        _customerInfo = customerInfoData;
                      },
                    ),
                  ),
                  Visibility(
                    visible: !widget.willUpdateOrder,
                    child: PaymentMethodView(
                      initMethod: _paymentMethod,
                      initChannel: _paymentChannel,
                      onChanged: (paymentMethod, paymentChannel) {
                        _paymentMethod = paymentMethod;
                        _paymentChannel = paymentChannel;
                        _paymentChanelNotifier.value = _paymentChannel;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.willUpdateOrder
              ? OrderActionButton(
                  buttonText: AppStrings.update_order.tr(),
                  enable: true,
                  loading: false,
                  totalPrice: widget.checkoutData.cartBill.totalPrice,
                  onProceed: () => _placeOrder(CheckoutState.PLACE_ORDER),
                )
              : ValueListenableBuilder<int?>(
                  valueListenable: _paymentChanelNotifier,
                  builder: (_, chanelID, __) {
                    return CheckoutActionButton(
                      willShowPlaceOrder: chanelID != PaymentChannelID.CREATE_QRIS,
                      totalPrice: widget.checkoutData.cartBill.totalPrice,
                      onPayNow: () => _placeOrder(CheckoutState.PAY_NOW),
                      onPlaceOrder: () => _placeOrder(CheckoutState.PLACE_ORDER),
                    );
                  },
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _paymentChanelNotifier.dispose();
    super.dispose();
  }
}
