import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/order.dart';

class DeliveryAddressView extends StatelessWidget {
  final Order order;

  const DeliveryAddressView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return (order.deliveryAddress.isNotEmpty || order.deliveryInfo != null)
        ? Container(
            margin: EdgeInsets.only(top: 8.rh,right: 8),
            padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 16.rw),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 16.0.rw,
                  runSpacing: 8.0.rh,
                  children: [
                    if (order.isMerchantDelivery && order.deliveryAddress.isNotEmpty)
                      _infoItem(
                        AppStrings.delivery_address.tr(),
                        order.deliveryAddress,
                      ),
                    if (!order.isMerchantDelivery && order.deliveryInfo!.address.isNotEmpty)
                      _infoItem(
                        AppStrings.delivery_address.tr(),
                        order.deliveryInfo?.address ?? EMPTY,
                      ),
                    if (!order.isMerchantDelivery && order.deliveryInfo!.keywords.isNotEmpty)
                      _infoItem(
                        AppStrings.address_instruction.tr(),
                        order.deliveryInfo?.keywords ?? EMPTY,
                      ),
                    if (!order.isMerchantDelivery && order.deliveryInfo!.instruction.isNotEmpty)
                      _infoItem(
                        AppStrings.delivery_instruction.tr(),
                        order.deliveryInfo?.instruction ?? EMPTY,
                      ),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget _infoItem(String title, String description) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Text(
          title,
          style: mediumTextStyle(
            color: AppColors.neutralB700,
            fontSize: 14.rSp,
          ),
        ),
        SizedBox(height: 2.rh),
        SizedBox(
          width: ScreenSizes.screenWidth/3,
          child: Text(
            description,
            style: regularTextStyle(
              color: AppColors.neutralB500,
              fontSize: 12.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
