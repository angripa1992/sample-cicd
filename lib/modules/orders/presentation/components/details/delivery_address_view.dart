import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/order.dart';

class DeliveryAddressView extends StatelessWidget {
  final Order order;

  const DeliveryAddressView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return order.deliveryInfo == null ? const SizedBox() : Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s8.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: order.deliveryInfo!.address.isNotEmpty,
            child: _item('Delivery Address', order.deliveryInfo!.address),
          ),
          Visibility(
            child: _item('Address Instruction',  order.deliveryInfo!.keywords),
          ),
          Visibility(
            child: _item('Delivery Instruction',  order.deliveryInfo!.instruction),
          ),
        ],
      ),
    );
  }

  Widget _item(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.s8.rh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: semiBoldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s15.rSp,
            ),
          ),
          SizedBox(height: AppSize.s4.rh),
          Text(
            description,
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ],
      ),
    );
  }
}
