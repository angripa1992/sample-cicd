import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/provider/order_information_provider.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/payment_info.dart';
import '../dialogs/add_payment_method_and_status.dart';

class OrderPaymentInfoView extends StatefulWidget {
  final Order order;

  const OrderPaymentInfoView({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderPaymentInfoView> createState() => _OrderPaymentInfoViewState();
}

class _OrderPaymentInfoViewState extends State<OrderPaymentInfoView> {
  late Order _order;

  void _onPaymentInfoChanged(int method, int status) {
    setState(() {
      _order.paymentMethod = method;
      _order.paymentStatus = status;
    });
  }

  @override
  void initState() {
    _order = widget.order;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Column(
        children: [
          if (widget.order.paymentStatus > 0)
            OrderPaymentStatusView(
              order: _order,
              onPaymentInfoChanged: _onPaymentInfoChanged,
            ),
          if (widget.order.paymentStatus > 0)
            Divider(color: AppColors.frenchGrey),
          if (widget.order.paymentMethod > 0)
            OrderPaymentMethodView(
              order: _order,
              onPaymentInfoChanged: _onPaymentInfoChanged,
            ),
          if (widget.order.paymentMethod > 0)
            Divider(color: AppColors.frenchGrey),
        ],
      ),
    );
  }
}

class OrderPaymentMethodView extends StatelessWidget {
  final _provider = getIt.get<OrderInformationProvider>();
  final Order order;
  final Function(int, int) onPaymentInfoChanged;

  OrderPaymentMethodView(
      {Key? key, required this.order, required this.onPaymentInfoChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Payment Method',
          style: getRegularTextStyle(
            color: AppColors.balticSea,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        FutureBuilder<PaymentMethod>(
          future: _provider.fetchPaymentMethod(order.paymentMethod),
          builder: (_, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return PaymentInfoTagView(
                tagName: snapshot.data!.title,
                order: order,
                onPaymentInfoChanged: onPaymentInfoChanged,
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}

class OrderPaymentStatusView extends StatelessWidget {
  final _provider = getIt.get<OrderInformationProvider>();
  final Order order;
  final Function(int, int) onPaymentInfoChanged;

  OrderPaymentStatusView(
      {Key? key, required this.order, required this.onPaymentInfoChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Payment Status',
          style: getRegularTextStyle(
            color: AppColors.balticSea,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        FutureBuilder<PaymentStatus>(
          future: _provider.fetchPaymentStatus(order.paymentStatus),
          builder: (_, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return PaymentInfoTagView(
                tagName: snapshot.data!.title,
                order: order,
                onPaymentInfoChanged: onPaymentInfoChanged,
              );
            }
            return const SizedBox();
          },
        )
      ],
    );
  }
}

class PaymentInfoTagView extends StatelessWidget {
  final String tagName;
  final Order order;
  final Function(int, int) onPaymentInfoChanged;

  const PaymentInfoTagView({
    Key? key,
    required this.tagName,
    required this.order,
    required this.onPaymentInfoChanged,
  }) : super(key: key);

  bool _isWebshopPostPayment() {
    return order.providerId == ProviderID.KLIKIT &&
        !order.isManualOrder &&
        order.paymentStatus != PaymentStatusId.paid;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(_isWebshopPostPayment()){
          showAddPaymentStatusMethodDialog(
            title: 'Update Payment Info',
            context: context,
            willOnlyUpdatePaymentInfo: true,
            onSuccess: onPaymentInfoChanged,
            order: order,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s16.rSp),
          color: AppColors.purpleBlue,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s12.rw,
            vertical: AppSize.s4.rh,
          ),
          child: Row(
            children: [
              Text(
                tagName,
                style: getMediumTextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSize.s12.rSp,
                ),
              ),
              if (_isWebshopPostPayment())
                Padding(
                  padding: EdgeInsets.only(left: AppSize.s8.rw),
                  child: Icon(
                    Icons.edit,
                    size: AppSize.s16.rSp,
                    color: AppColors.white,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
