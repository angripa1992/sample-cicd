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

class OrderActionButton extends StatelessWidget {
  final String buttonText;
  final bool enable;
  final bool loading;
  final num totalPrice;
  final VoidCallback onProceed;

  const OrderActionButton({
    Key? key,
    required this.enable,
    required this.totalPrice,
    required this.onProceed,
    required this.buttonText,
    required this.loading,
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
          ElevatedButton(
            onPressed: enable ? onProceed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: enable ? AppColors.primary : AppColors.grey,
            ),
            child: loading
                ? SizedBox(
                    height: AppSize.s14.rh,
                    width: AppSize.s16.rw,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
                    child: Text(
                      buttonText,
                      style: mediumTextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
