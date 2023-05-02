import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class ProceedCheckoutButton extends StatelessWidget {
  final bool enable;
  final num totalPrice;
  final VoidCallback onProceed;

  const ProceedCheckoutButton({
    Key? key,
    required this.enable,
    required this.totalPrice,
    required this.onProceed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Total',
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              SizedBox(width: AppSize.s4.rw),
              Text(
                '(including VAT)',
                style: getRegularTextStyle(
                  color: AppColors.dustyGreay,
                ),
              ),
              const Spacer(),
              Text(
                '${CartManager().currency().symbol} $totalPrice',
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
            onPressed:onProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleBlue,
            ),
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: AppSize.s10.rh),
              child: Text(
                'Proceed to Checkout',
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
