import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/pament_method.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/checkout/payment_status.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../app/di.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../utils/order_entity_provider.dart';
import '../cart/order_action_button.dart';
import '../cart/step_view.dart';
import 'customer_info.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutData checkoutData;
  final VoidCallback onSuccess;

  const CheckoutScreen({
    Key? key,
    required this.checkoutData,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _paymentMethodNotifier = ValueNotifier<int?>(null);
  CustomerInfo? _customerInfo;
  int? _paymentStatus;
  int? _paymentMethod;
  int? _paymentChannel;

  @override
  void initState() {
    final paymentInfo = CartManager().paymentInfo;
    if (paymentInfo != null) {
      _paymentMethod = paymentInfo.paymentMethod;
      _paymentChannel = paymentInfo.paymentChannel;
      _paymentMethodNotifier.value = paymentInfo.paymentMethod;
      _paymentStatus = paymentInfo.paymentStatus;
    }
    _customerInfo = CartManager().customerInfo;
    super.initState();
  }

  @override
  void dispose() {
    _paymentMethodNotifier.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    EasyLoading.show();
    final body = await OrderEntityProvider().placeOrderRequestData(
      checkoutData: widget.checkoutData,
      paymentStatus: _paymentMethod == null ? PaymentStatusId.pending : (_paymentStatus ?? PaymentStatusId.pending),
      paymentMethod: _paymentMethod,
      paymentChannel: _paymentChannel,
      info: _customerInfo,
    );
    final response = await getIt.get<AddOrderRepository>().placeOrder(body: body);
    EasyLoading.dismiss();
    response.fold(
      (failure) {
        showApiErrorSnackBar(context, failure);
      },
      (successResponse) {
        showSuccessSnackBar(context, successResponse.message ?? '');
        if (CartManager().willUpdateOrder) {
          CartManager().clearAndNavigateToOrderScreen(context);
        } else {
          CartManager().clearAndNavigateToAddOrderScreen(context);
        }
      },
    );
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
                  CustomerInfoView(
                    initInfo: _customerInfo,
                    onCustomerInfoSave: (customerInfoData) {
                      _customerInfo = customerInfoData;
                    },
                  ),
                  PaymentMethodView(
                    initMethod: _paymentMethod,
                    initChannel: _paymentChannel,
                    onChanged: (paymentMethod, paymentChannel) {
                      _paymentMethod = paymentMethod;
                      _paymentChannel = paymentChannel;
                      _paymentMethodNotifier.value = _paymentMethod;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: _paymentMethodNotifier,
                    builder: (_, paymentMethod, __) {
                      if (paymentMethod == null) {
                        return const SizedBox();
                      } else {
                        return PaymentStatusView(
                          initStatus: _paymentStatus,
                          onChanged: (paymentStatus) {
                            _paymentStatus = paymentStatus;
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          OrderActionButton(
            buttonText: CartManager().willUpdateOrder ? AppStrings.update_order.tr() : AppStrings.placed_order.tr(),
            enable: true,
            totalPrice: widget.checkoutData.cartBill.totalPrice,
            onProceed: _placeOrder,
            loading: false,
          ),
        ],
      ),
    );
  }
}
