import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/common/entities/branch.dart';

import '../../../../../../app/extensions.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class PlaceOrderButton extends StatelessWidget {
  final int? channelID;
  final Branch branch;
  final num totalPrice;
  final bool isWebShopOrder;
  final bool willUpdateOrder;
  final VoidCallback onPlaceOrder;
  final VoidCallback onPayNow;
  final VoidCallback onUpdateWebshopOrder;
  final VoidCallback onUpdateOrder;

  const PlaceOrderButton({
    Key? key,
    required this.channelID,
    required this.branch,
    required this.totalPrice,
    required this.isWebShopOrder,
    required this.willUpdateOrder,
    required this.onPayNow,
    required this.onPlaceOrder,
    required this.onUpdateOrder,
    required this.onUpdateWebshopOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = CartManager().currency;

    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s8.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                AppStrings.total.tr(),
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              SizedBox(width: AppSize.s4.rw),
              Text(
                AppStrings.inc_vat.tr(),
                style: regularTextStyle(
                  color: AppColors.greyDarker,
                ),
              ),
              const Spacer(),
              Text(
                PriceCalculator.formatPrice(
                  price: totalPrice,
                  code: currency.code ?? EMPTY,
                  symbol: currency.symbol ?? EMPTY,
                ),
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.s8.rh),
          Row(
            children: [
              if (isWebShopOrder && willUpdateOrder)
                Expanded(
                  child: KTButton(
                    backgroundDecoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8.rSp)),
                    labelStyle: mediumTextStyle(color: AppColors.white, fontSize: 14.rSp),
                    onTap: onUpdateWebshopOrder,
                    controller: KTButtonController(label: AppStrings.update_order.tr()),
                  ),
                ),
              if (!isWebShopOrder && willUpdateOrder)
                Expanded(
                  child: KTButton(
                    backgroundDecoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8.rSp)),
                    labelStyle: mediumTextStyle(color: AppColors.white, fontSize: 14.rSp),
                    onTap: onPlaceOrder,
                    controller: KTButtonController(label: AppStrings.update_order.tr()),
                  ),
                ),
              if (!willUpdateOrder && branch.prePaymentEnabled)
                Expanded(
                  child: KTButton(
                    backgroundDecoration: BoxDecoration(color: AppColors.neutralB30, borderRadius: BorderRadius.circular(8.rSp)),
                    labelStyle: mediumTextStyle(color: AppColors.neutralB700, fontSize: 14.rSp),
                    onTap: onPayNow,
                    controller: KTButtonController(label: 'Pay Now'),
                  ),
                ),
              if (!willUpdateOrder && branch.prePaymentEnabled && branch.postPaymentEnabled && channelID != PaymentChannelID.CREATE_QRIS) SizedBox(width: 16.rw),
              if (!willUpdateOrder && branch.postPaymentEnabled && channelID != PaymentChannelID.CREATE_QRIS)
                Expanded(
                  child: KTButton(
                    backgroundDecoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8.rSp)),
                    labelStyle: mediumTextStyle(color: AppColors.white, fontSize: 14.rSp),
                    onTap: onPlaceOrder,
                    controller: KTButtonController(label: 'Place Order'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
