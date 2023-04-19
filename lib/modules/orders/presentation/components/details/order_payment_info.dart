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

class OrderPaymentInfoView extends StatelessWidget {
  final Order order;

  const OrderPaymentInfoView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Column(
        children: [
          OrderPaymentStatusView(order: order),
          Divider(color: AppColors.purpleBlue),
          if(order.paymentStatus == PaymentStatusId.paid)
          OrderPaymentMethodView(order: order),
          if(order.paymentStatus == PaymentStatusId.paid)
          Divider(color: AppColors.purpleBlue),
        ],
      ),
    );
  }
}

class OrderPaymentMethodView extends StatelessWidget {
  final _provider = getIt.get<OrderInformationProvider>();
  final Order order;

  OrderPaymentMethodView({Key? key, required this.order}) : super(key: key);

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
              return PaymentInfoTagView(tagName: snapshot.data!.title);
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

  OrderPaymentStatusView({Key? key, required this.order}) : super(key: key);

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
              return PaymentInfoTagView(tagName: snapshot.data!.title);
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

  const PaymentInfoTagView({
    Key? key,
    required this.tagName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s16.rSp),
        color: AppColors.purpleBlue,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s12.rw,
          vertical: AppSize.s4.rh,
        ),
        child: Text(
          tagName,
          style: getMediumTextStyle(
            color: AppColors.white,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
      ),
    );
  }
}
