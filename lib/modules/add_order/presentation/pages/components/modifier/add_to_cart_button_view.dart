import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/quantity_selector.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';

class AddToCartButtonView extends StatelessWidget {
  final ValueNotifier<bool> enabled;
  final ValueNotifier<num> price;
  final int quantity;
  final String currencySymbol;
  final String currencyCode;
  final Function(int) onQuantityChanged;
  final VoidCallback onAddToCart;

  const AddToCartButtonView({
    Key? key,
    required this.enabled,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
    required this.currencySymbol,
    required this.onAddToCart,
    required this.currencyCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSize.s1.rh),
      padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
        child: Row(
          children: [
            QuantitySelector(
              quantity: quantity,
              onQuantityChanged: onQuantityChanged,
            ),
            const Spacer(),
            ValueListenableBuilder<bool>(
                valueListenable: enabled,
                builder: (_, enabled, __) {
                  return InkWell(
                    onTap: enabled ? onAddToCart : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: enabled
                            ? AppColors.purpleBlue
                            : AppColors.smokeyGrey,
                        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.s4.rh,
                          horizontal: AppSize.s16.rw,
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.add_to_cart,
                              style: regularTextStyle(
                                color: AppColors.white,
                              ),
                            ),
                            ValueListenableBuilder<num>(
                                valueListenable: price,
                                builder: (_, price, __) {
                                  return Text(
                                    PriceCalculator.formatPrice(
                                      price: price,
                                      currencySymbol: currencySymbol,
                                      code: currencyCode,
                                    ),
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: AppFontSize.s14.rSp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
