import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../order_item/three_pl_status.dart';
import 'order_payment_info.dart';

class OrderTagsView extends StatelessWidget {
  final Order order;
  final bool isCustomBank;
  final VoidCallback onSwitchRider;
  static const _type = 'type';
  static const _typeColor = 'type_color';

  const OrderTagsView({
    Key? key,
    required this.order,
    this.isCustomBank = false,
    required this.onSwitchRider,
  }) : super(key: key);

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

  Map<String, dynamic> _getType() {
    final type = order.type;
    final pickupType = order.pickupType;
    if (type == OrderType.PICKUP && pickupType == PickupType.DRIVE_THRU) {
      return {
        _type: 'Drive Thru',
        _typeColor: 0xFF0468E4,
      };
    } else if (type == OrderType.PICKUP && pickupType == PickupType.DEFAULT) {
      return {
        _type: AppStrings.pickup.tr(),
        _typeColor: 0xFF0468E4,
      };
    } else if (type == OrderType.DELIVERY) {
      return {
        _type: AppStrings.deliver.tr(),
        _typeColor: 0xFFFFA133,
      };
    } else {
      return {
        _type: AppStrings.dine_in.tr(),
        _typeColor: 0xFF27AE60,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            runSpacing: AppSize.s8.rh,
            spacing: AppSize.s8.rw,
            children: [
              _orderTypeTagView(_getType()),
              if (order.providerId == ProviderID.KLIKIT) _tagView(order.isManualOrder ? AppStrings.manual.tr() : AppStrings.webshop.tr()),
              if (order.providerId == ProviderID.KLIKIT && order.tableNo.isNotEmpty) _tagView('${AppStrings.table_no.tr()} ${order.tableNo}'),
              if (isCustomBank) _tagView(AppStrings.custom_bank.tr()),
              KTChip(
                text: _getStatus(),
                textStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB500),
                strokeColor: order.status == OrderStatus.CANCELLED ? AppColors.errorR300 : AppColors.primaryP300,
                backgroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
              ),
              if (order.orderAppliedPromo != null && order.orderAppliedPromo!.isSeniorCitizenPromo!) _tagView('SC/PWD'),
            ],
          ),
        ),
        AppSize.s10.verticalSpacer(),
        Row(
          children: [
            OrderPaymentInfoView(order: order),
            ThreePlStatus(order: order, showTag: true, onSwitchRider: onSwitchRider),
          ],
        ),
      ],
    );
  }

  Widget _tagView(String tagName) {
    return KTChip(
      text: tagName,
      textStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB500),
      strokeColor: AppColors.neutralB40,
      backgroundColor: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
    );
  }

  Widget _orderTypeTagView(Map<String, dynamic> typeMap) {
    return KTChip(
      text: typeMap[_type]!,
      textStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.white),
      strokeColor: Color(typeMap[_typeColor]!),
      backgroundColor: Color(typeMap[_typeColor]!),
      padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
    );
  }
}
