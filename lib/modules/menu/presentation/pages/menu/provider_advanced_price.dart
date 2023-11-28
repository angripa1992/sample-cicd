import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/modules/common/entities/provider.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/resources/colors.dart';

import '../../../../../app/di.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../common/business_information_provider.dart';
import '../../../../widgets/image_view.dart';
import '../../../domain/entities/menu/menu_item_price.dart';
import 'advanced_pricing_tags.dart';

class ProviderAdvancePrice extends StatelessWidget {
  final MenuCategoryItem menuCategoryItem;

  const ProviderAdvancePrice({
    super.key,
    required this.menuCategoryItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _klikitPriceBreakdown(menuCategoryItem.klikitPrice()),
        SizedBox(height: AppSize.s8.rh),
        _providerPriceTile(menuCategoryItem.prices.firstWhere((element) => element.providerId == ProviderID.GRAB_FOOD)),
        Column(
          children: menuCategoryItem.prices.map((providerPrice) {
            if (providerPrice.providerId == ProviderID.KLIKIT || providerPrice.providerId == ProviderID.GRAB_FOOD) {
              return const SizedBox();
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
              child: _providerPriceTitle(providerPrice),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _providerPriceTile(MenuItemPrice price) {
    return ListTileTheme(
      contentPadding: const EdgeInsets.all(0),
      horizontalTitleGap: 8,
      minLeadingWidth: 0,
      child: ExpansionTile(
        textColor: AppColors.black,
        collapsedTextColor: AppColors.black,
        iconColor: AppColors.black,
        collapsedIconColor: AppColors.black,
        childrenPadding: EdgeInsets.only(bottom: AppSize.s8.rh),
        initiallyExpanded: true,
        title: _providerPriceTitle(price),
        children: [
          MenuAdvancedPriceTags(price: price),
        ],
      ),
    );
  }

  Widget _providerPriceTitle(MenuItemPrice price) {
    return FutureBuilder<Provider>(
      future: getIt.get<BusinessInformationProvider>().findProviderById(price.providerId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final provider = snapshot.data!;
          return Row(
            children: [
              ClipOval(
                child: ImageView(
                  path: provider.logo,
                  width: AppSize.s28.rw,
                  height: AppSize.s24.rh,
                ),
              ),
              SizedBox(width: AppSize.s8.rw),
              Text(
                '${provider.title}  ${PriceCalculator.formatPrice(
                  price: price.price(),
                  symbol: price.currencySymbol,
                  code: price.currencyCode,
                )}',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _klikitPriceBreakdown(MenuItemPrice price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Price ${PriceCalculator.formatPrice(
            price: price.price(),
            symbol: price.currencySymbol,
            code: price.currencyCode,
          )}',
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(height: AppSize.s8.rh),
        MenuAdvancedPriceTags(price: price),
      ],
    );
  }
}
