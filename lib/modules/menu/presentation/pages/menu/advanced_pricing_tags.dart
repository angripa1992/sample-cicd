import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';

import '../../../../../core/utils/price_calculator.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class MenuAdvancedPriceTags extends StatelessWidget {
  final int providerID;
  final MenuCategoryItem menuCategoryItem;

  const MenuAdvancedPriceTags({
    super.key,
    required this.menuCategoryItem,
    required this.providerID,
  });

  @override
  Widget build(BuildContext context) {
    final price = menuCategoryItem.prices.firstWhereOrNull((element) => element.providerId == providerID);
    return price == null
        ? const SizedBox()
        : Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              runSpacing: AppSize.s8.rh,
              spacing: AppSize.s8.rw,
              children: [
                if (price.takeAwayPrice > 0) _priceTag('Takeaway', price.takeAwayPrice, price.currencyCode, price.currencySymbol),
                if (price.advancedPrice.dineIn > 0) _priceTag('Dine In', price.advancedPrice.dineIn, price.currencyCode, price.currencySymbol),
                if (price.advancedPrice.pickup > 0) _priceTag('Pick Up', price.advancedPrice.pickup, price.currencyCode, price.currencySymbol),
                if (price.advancedPrice.delivery > 0) _priceTag('Delivery', price.advancedPrice.delivery, price.currencyCode, price.currencySymbol),
              ],
            ),
          );
  }

  Widget _priceTag(String tagName, num price, String cCode, String cSymbol) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s4.rh,
        horizontal: AppSize.s8.rw,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s24.rSp),
        border: Border.all(color: AppColors.greyDarker),
      ),
      child: Text(
        '$tagName ${PriceCalculator.formatPrice(price: price, symbol: cSymbol, code: cCode)}',
        style: regularTextStyle(
          color: AppColors.black,
          fontSize: AppFontSize.s12.rSp,
        ),
      ),
    );
  }
}
