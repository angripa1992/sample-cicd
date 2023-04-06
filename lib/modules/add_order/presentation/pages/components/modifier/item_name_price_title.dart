import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../domain/entities/item_price.dart';
import '../../../../utils/order_price_provider.dart';

class ItemNamePriceTitle extends StatelessWidget {
  final String name;
  final List<ItemPrice> prices;
  const ItemNamePriceTitle({Key? key, required this.name, required this.prices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            name,
            style: getRegularTextStyle(
              color: AppColors.balticSea,
              fontSize: AppFontSize.s15.rSp,
            ),
          ),
        ),
        Text(
          OrderPriceProvider.modifierPrice(prices),
          style: TextStyle(
            color: AppColors.balticSea,
            fontSize: AppFontSize.s15.rSp,
          ),
        ),
      ],
    );
  }
}
