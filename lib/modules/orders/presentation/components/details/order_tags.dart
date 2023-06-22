import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class OrderTagsView extends StatelessWidget {
  final Order order;

  const OrderTagsView({Key? key, required this.order}) : super(key: key);

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
      case OrderType.DINE_IN:
        return AppStrings.dine_in;
      default:
        return EMPTY;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = _getType();
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        runSpacing: AppSize.s8.rh,
        spacing: AppSize.s8.rw,
        children: [
          if (order.providerId == ProviderID.KLIKIT)
            _tagView(
              order.isManualOrder
                  ? AppStrings.manual.tr()
                  : AppStrings.webshop.tr(),
            ),
          if (order.providerId == ProviderID.KLIKIT &&
              !order.isManualOrder &&
              order.tableNo.isNotEmpty)
            _tagView('${AppStrings.table_no.tr()} ${order.tableNo}'),
          if (type.isNotEmpty) _tagView(_getType()),
          _tagView(_getStatus()),
        ],
      ),
    );
  }

  Widget _tagView(String tagName) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s4.rh,
        horizontal: AppSize.s8.rw,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s24.rSp),
        border: Border.all(color: AppColors.frenchGrey),
      ),
      child: Text(
        tagName,
        style: getRegularTextStyle(
          color: AppColors.bluewood,
          fontSize: AppFontSize.s12.rSp,
        ),
      ),
    );
  }
}
