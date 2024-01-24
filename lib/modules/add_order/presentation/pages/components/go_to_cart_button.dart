import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../core/utils/price_calculator.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/selected_item_price.dart';
import '../../../utils/cart_manager.dart';

class GoToCartButton extends StatelessWidget {
  final VoidCallback onGotoCart;

  const GoToCartButton({Key? key, required this.onGotoCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SelectedItemPrice?>(
        valueListenable: CartManager().cartItemPriceNotifier,
        builder: (_, value, __) {
          if (value == null) {
            return const SizedBox();
          } else {
            return InkWell(
              onTap: onGotoCart,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
                padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  color: AppColors.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${value.noOfItem} ${AppStrings.items.tr()}',
                      style: regularTextStyle(color: AppColors.white,fontSize: 12.rSp),
                    ),
                    Text(
                      'View Cart',
                      style: mediumTextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                    Text(
                      PriceCalculator.formatPrice(
                        price: value.totalPrice,
                        code: value.code,
                        symbol: value.currencySymbol,
                      ),
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.rSp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
