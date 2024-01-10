import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../common/entities/payment_info.dart';
import '../../../domain/entities/order.dart';
import '../dialogs/add_payment_method_and_status.dart';

class OrderPaymentInfoView extends StatefulWidget {
  final Order order;

  const OrderPaymentInfoView({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderPaymentInfoView> createState() => _OrderPaymentInfoViewState();
}

class _OrderPaymentInfoViewState extends State<OrderPaymentInfoView> {
  late Order _order;

  void _onPaymentInfoChanged(int method, int channel, int status) {
    setState(() {
      _order.paymentMethod = method;
      _order.paymentChannel = channel;
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
    return Row(
      children: [
        if (widget.order.paymentStatus > 0)
          OrderPaymentStatusView(
            order: _order,
            onPaymentInfoChanged: _onPaymentInfoChanged,
          ),
        SizedBox(width: AppSize.s8.rw),
        if (widget.order.paymentMethod > 0)
          OrderPaymentMethodView(
            order: _order,
            onPaymentInfoChanged: _onPaymentInfoChanged,
          ),
      ],
    );
  }
}

class OrderPaymentMethodView extends StatelessWidget {
  final _provider = getIt.get<BusinessInformationProvider>();
  final Order order;
  final Function(int, int, int) onPaymentInfoChanged;

  OrderPaymentMethodView({
    Key? key,
    required this.order,
    required this.onPaymentInfoChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaymentMethod>(
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
    );
  }
}

class OrderPaymentStatusView extends StatelessWidget {
  final _provider = getIt.get<BusinessInformationProvider>();
  final Order order;
  final Function(int, int, int) onPaymentInfoChanged;

  OrderPaymentStatusView({Key? key, required this.order, required this.onPaymentInfoChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaymentStatus>(
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
    );
  }
}

class PaymentInfoTagView extends StatelessWidget {
  final String tagName;
  final Order order;
  final Function(int, int, int) onPaymentInfoChanged;

  const PaymentInfoTagView({
    Key? key,
    required this.tagName,
    required this.order,
    required this.onPaymentInfoChanged,
  }) : super(key: key);

  bool _isWebshopPostPayment() {
    return order.providerId == ProviderID.KLIKIT && !order.isManualOrder && order.paymentStatus != PaymentStatusId.paid;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_isWebshopPostPayment()) {
          showAddPaymentStatusMethodDialog(
            title: AppStrings.update_payment_info.tr(),
            context: context,
            isWebShopPostPayment: true,
            onSuccess: onPaymentInfoChanged,
            order: order,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s2.rh,
        ),
        decoration: BoxDecoration(
          color: AppColors.neutralB20,
          borderRadius: BorderRadius.circular(AppSize.s24.rSp),
          border: Border.all(color: AppColors.neutralB40),
        ),
        child: Row(
          children: [
            Text(
              tagName,
              style: regularTextStyle(
                color: AppColors.neutralB500,
                fontSize: AppFontSize.s12.rSp,
              ),
            ),
            if (_isWebshopPostPayment())
              ImageResourceResolver.writeSVG
                  .getImageWidget(width: AppSize.s14.rw, height: AppSize.s14.rh, color: AppColors.neutralB400)
                  .setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s4.rw)
          ],
        ),
      ),
    );
  }
}
