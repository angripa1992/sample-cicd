import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class OrderStatusView extends StatelessWidget {
  final Order order;

  const OrderStatusView({Key? key, required this.order}) : super(key: key);

  String _getStatus() {
    switch (order.status) {
      case OrderStatus.ACCEPTED:
        return AppStrings.accepted.tr();
      case OrderStatus.PLACED:
        return AppStrings.placed.tr();
      case OrderStatus.CANCELLED:
        return AppStrings.canceled.tr();
      case OrderStatus.DELIVERED:
        return AppStrings.delivered.tr();
      case OrderStatus.PICKED_UP:
        return AppStrings.picked_up.tr();
      case OrderStatus.READY:
        return AppStrings.ready.tr();
      case OrderStatus.SCHEDULED:
        return AppStrings.scheduled.tr();
      case OrderStatus.DRIVER_ARRIVED:
        return AppStrings.driver_arrived.tr();
      case OrderStatus.DRIVER_ASSIGNED:
        return AppStrings.driver_assigned.tr();
      default:
        return '';
    }
  }

  String _getType() {
    switch (order.type) {
      case OrderType.PICKUP:
        return AppStrings.pickup.tr();
      case OrderType.DELIVERY:
        return AppStrings.deliver.tr();
      default:
        return AppStrings.manual.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppSize.s12.rh),
          child: _statusItem(_getStatus()),
        ),
        Padding(
          padding: EdgeInsets.only(left: AppSize.s24.rw, top: AppSize.s12.rh),
          child: _statusItem(_getType()),
        ),
      ],
    );
  }

  Widget _statusItem(String text) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s16.rSp),
        color: AppColors.purpleBlue,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s4.rh,
          horizontal: AppSize.s12.rw,
        ),
        child: Text(
          text.toUpperCase(),
          style: getBoldTextStyle(
            color: AppColors.white,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
      ),
    );
  }
}
