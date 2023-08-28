import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../app/enums.dart';
import '../../../../../core/utils/price_calculator.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/menu/menu_available_times.dart';
import '../../../../menu/domain/entities/menu/menu_item.dart';
import '../../../utils/available_time_provider.dart';
import 'menu_item_image_view.dart';

class MenuCategoryItemView extends StatelessWidget {
  final MenuCategoryItem menuItem;
  final MenuDay dayInfo;
  final VoidCallback onAddItem;

  const MenuCategoryItemView(
      {Key? key,
      required this.menuItem,
      required this.dayInfo,
      required this.onAddItem})
      : super(key: key);

  Availability _checkAvailability() {
    if (!menuItem.outOfStock.available) {
      return Availability.OUT_OF_STOCK;
    } else if (AvailableTimeProvider().haveAvailableTime(dayInfo) == null) {
      return Availability.UNAVAILABLE;
    } else {
      return Availability.STOCK;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availability = _checkAvailability();
    final menuItemPrice = menuItem.klikitPrice();
    return SizedBox(
      width: AppSize.s100.rw,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: availability == Availability.OUT_OF_STOCK ? null : onAddItem,
              child: SizedBox(
                height: AppSize.s100.rh,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  clipBehavior: Clip.none,
                  children: [
                    MenuItemImageView(
                      image: menuItem.image,
                      availability: availability,
                    ),
                    Positioned(
                      bottom: 8,
                      child: Container(
                        width: AppSize.s90.rw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.primary,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSize.s8.rw,
                              vertical: AppSize.s2.rh),
                          child: Text(
                            PriceCalculator.formatPrice(
                              price: menuItemPrice.price,
                              code: menuItemPrice.currencyCode,
                              symbol: menuItemPrice.currencySymbol,
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppFontSize.s12.rSp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                          color: AppColors.white,
                        ),
                        child: Icon(
                          Icons.add_circle,
                          size: AppSize.s28.rSp,
                          color: availability == Availability.OUT_OF_STOCK
                              ? AppColors.greyLight
                              : AppColors.primary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap:
                  availability == Availability.OUT_OF_STOCK ? null : onAddItem,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s4.rw,
                  vertical: AppSize.s8.rh,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        menuItem.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: AppSize.s4.rw),
                    Icon(Icons.info_outline, size: AppSize.s16.rSp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
