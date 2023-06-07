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
        valueListenable: CartManager().getPriceNotifyListener(),
        builder: (_, value, __) {
          if (value == null) {
            return const SizedBox();
          } else {
            return InkWell(
              onTap: onGotoCart,
              child: Container(
                margin: EdgeInsets.only(
                  left: AppSize.s8.rw,
                  right: AppSize.s8.rw,
                  bottom: AppSize.s4.rh,
                  top: AppSize.s4.rh,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  color: AppColors.purpleBlue,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s12.rw,
                    vertical: AppSize.s8.rh,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${value.noOfItem} ${AppStrings.items.tr()}',
                            style: getRegularTextStyle(color: AppColors.white),
                          ),
                          SizedBox(height: AppSize.s2.rh),
                          Text(
                            PriceCalculator.formatPrice(
                              price: value.totalPrice,
                              currencySymbol: value.currencySymbol,
                              code: value.code,
                            ),
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: AppFontSize.s16.rSp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            AppStrings.go_to_cart,
                            style: getMediumTextStyle(
                              color: AppColors.white,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                          Icon(Icons.arrow_right, color: AppColors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
