import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../app/extensions.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/app_button.dart';

class CheckoutActionButton extends StatelessWidget {
  final num totalPrice;
  final VoidCallback onPlaceOrder;
  final VoidCallback onPayNow;

  const CheckoutActionButton({
    Key? key,
    required this.totalPrice,
    required this.onPayNow,
    required this.onPlaceOrder,
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
              Expanded(
                child: AppButton(
                  onTap: onPayNow,
                  text: 'Pay Now',
                  textColor: AppColors.black,
                  color: AppColors.greyDark,
                  borderColor: AppColors.greyDark,

                ),
              ),
              SizedBox(width: AppSize.s8.rw),
              Expanded(
                child: AppButton(
                  onTap: onPlaceOrder,
                  text: AppStrings.placed_order.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
