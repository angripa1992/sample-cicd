import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class OrderStatusView extends StatelessWidget {
  final Order order;

  OrderStatusView({Key? key, required this.order}) : super(key: key);

  final _style = getBoldTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s14.rSp,
  );

  String _getStatus() {
    switch (order.status) {
      case OrderStatus.ACCEPTED:
        return 'Accepted';
      case OrderStatus.PLACED:
        return 'Placed';
      case OrderStatus.CANCELLED:
        return 'Canceled';
      case OrderStatus.DELIVERED:
        return 'Delivered';
      case OrderStatus.PICKED_UP:
        return 'Picked Up';
      case OrderStatus.READY:
        return 'Ready';
      case OrderStatus.SCHEDULED:
        return 'Scheduled';
      case OrderStatus.DRIVER_ARRIVED:
        return 'Driver Arrived';
        case OrderStatus.DRIVER_ASSIGNED:
        return 'Driver Assigned';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppSize.s12.rh),
          child: Text(_getStatus(), style: _style),
        ),
        Visibility(
          visible: (order.isManualOrder),
          child: Padding(
            padding: EdgeInsets.only(left: AppSize.s24.rw, top: AppSize.s12.rh),
            child: Text('Manual', style: _style),
          ),
        ),
        Visibility(
          visible: (order.type == OrderType.PICKUP),
          child: Padding(
            padding: EdgeInsets.only(left: AppSize.s24.rw, top: AppSize.s12.rh),
            child: Text('Pickup', style: _style),
          ),
        ),
      ],
    );
  }
}
