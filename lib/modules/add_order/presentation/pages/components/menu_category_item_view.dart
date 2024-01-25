import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/menu_item_add_button.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../app/enums.dart';
import '../../../../../core/utils/price_calculator.dart';
import '../../../../menu/domain/entities/menu/menu_available_times.dart';
import '../../../../menu/domain/entities/menu/menu_item.dart';
import '../../../utils/available_time_provider.dart';
import 'menu_item_image_view.dart';

class MenuCategoryItemView extends StatelessWidget {
  final MenuCategoryItem menuItem;
  final MenuDay dayInfo;
  final VoidCallback onAddNonModifierItem;
  final VoidCallback onAddModifierItem;
  final VoidCallback onRemoveNonModifierItem;

  const MenuCategoryItemView({
    Key? key,
    required this.menuItem,
    required this.dayInfo,
    required this.onAddModifierItem,
    required this.onAddNonModifierItem,
    required this.onRemoveNonModifierItem,
  }) : super(key: key);

  MenuAvailability _checkAvailability() {
    if (!menuItem.outOfStock.available) {
      return MenuAvailability.OUT_OF_STOCK;
    } else if (MenuAvailableTimeProvider().haveAvailableTime(dayInfo) == null) {
      return MenuAvailability.UNAVAILABLE;
    } else {
      return MenuAvailability.AVAILABLE;
    }
  }

  // onTap: availability == MenuAvailability.OUT_OF_STOCK ? null : onAddItem,

  @override
  Widget build(BuildContext context) {
    final availability = _checkAvailability();
    return Container(
      width: 100.rw,
      padding: EdgeInsets.symmetric(horizontal: 4.rw),
      child: Column(
        children: [
          SizedBox(
            height: 90.rh,
            child: Stack(
              alignment: AlignmentDirectional.center,
              clipBehavior: Clip.none,
              children: [
                MenuItemImageView(
                  image: menuItem.image,
                  availability: availability,
                ),
                if (availability == MenuAvailability.AVAILABLE)
                  Positioned(
                    bottom: 8,
                    child: MenuItemAddCounterButton(
                      menuItem: menuItem,
                      onAddModifierItem: onAddModifierItem,
                      onAddNonModifierItem: onAddNonModifierItem,
                      onRemoveNonModifierItem: onRemoveNonModifierItem,
                    ),
                  ),
              ],
            ),
          ),
          _nameAndPrice(availability),
        ],
      ),
    );
  }

  Widget _nameAndPrice(MenuAvailability menuAvailability) {
    final menuItemPrice = menuItem.klikitPrice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.rh),
          child: Text(
            '${menuItem.title} ${menuItem.title} ${menuItem.title}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: mediumTextStyle(
              color: menuAvailability == MenuAvailability.AVAILABLE ? AppColors.neutralB700 : AppColors.blur,
              fontSize: 14.rSp,
            ),
          ),
        ),
        Text(
          PriceCalculator.formatPrice(
            price: menuItemPrice.advancePrice(CartManager().orderType),
            code: menuItemPrice.currencyCode,
            symbol: menuItemPrice.currencySymbol,
          ),
          style: TextStyle(
            color: menuAvailability == MenuAvailability.AVAILABLE ? AppColors.neutralB200 : AppColors.blur,
            fontWeight: FontWeight.normal,
            fontSize: 14.rSp,
          ),
        )
      ],
    );
  }
}
