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
    final currency = CartManager().currency();
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
                AppStrings.total.tr() ,
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              SizedBox(width: AppSize.s4.rw),
              Text(
                AppStrings.inc_vat.tr(),
                style: getRegularTextStyle(
                  color: AppColors.dustyGreay,
                ),
              ),
              const Spacer(),
              Text(
                PriceCalculator.formatPrice(
                  price: totalPrice,
                  currencySymbol: currency.symbol ?? EMPTY,
                  code: currency.code ?? EMPTY,
                ),
                style: TextStyle(
                  color: AppColors.balticSea,
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
              backgroundColor:
                  enable ? AppColors.purpleBlue : AppColors.whiteSmoke,
            ),
            child: loading
                ? SizedBox(
                    height: AppSize.s14.rh,
                    width: AppSize.s16.rw,
                    child: CircularProgressIndicator(
                      color: AppColors.purpleBlue,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
                    child: Text(
                      buttonText,
                      style: getMediumTextStyle(
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
