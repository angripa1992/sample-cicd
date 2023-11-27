import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/modules/common/entities/provider.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/resources/colors.dart';

import '../../../../../resources/values.dart';
import '../../../../widgets/image_view.dart';
import 'advanced_pricing_tags.dart';

class ProviderAdvancePrice extends StatelessWidget {
  final Provider provider;
  final MenuCategoryItem menuCategoryItem;

  const ProviderAdvancePrice({
    super.key,
    required this.provider,
    required this.menuCategoryItem,
  });

  @override
  Widget build(BuildContext context) {
    final price = menuCategoryItem.prices.firstWhereOrNull((element) => element.providerId == provider.id);
    return price == null || price.price() <= 0
        ? const SizedBox()
        : ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            horizontalTitleGap: 8,
            minLeadingWidth: 0,
            child: ExpansionTile(
              textColor: AppColors.black,
              collapsedTextColor: AppColors.black,
              iconColor: AppColors.black,
              collapsedIconColor: AppColors.black,
              childrenPadding: EdgeInsets.only(bottom: AppSize.s8.rh),
              leading: ClipOval(
                child: ImageView(
                  path: provider.logo,
                  width: AppSize.s28.rw,
                  height: AppSize.s24.rh,
                ),
              ),
              title: Text(
                '${provider.title}  ${PriceCalculator.formatPrice(
                  price: price.price(),
                  symbol: price.currencySymbol,
                  code: price.currencyCode,
                )}',
              ),
              children: [
                MenuAdvancedPriceTags(
                  menuCategoryItem: menuCategoryItem,
                  providerID: provider.id,
                ),
              ],
            ),
          );
  }
}
