import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/avilable_times.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/item_modifier_group.dart';
import '../../../utils/available_time_provider.dart';
import '../../../utils/order_price_provider.dart';
import 'menu_item_description.dart';
import 'menu_item_image_view.dart';

class MenuItemView extends StatelessWidget {
  final MenuItems menuItem;
  final DayInfo dayInfo;
  final VoidCallback onAddItem;
  static const _outOfStock = 'Out of Stock';
  static const _unavailable = 'Unavailable';

  const MenuItemView(
      {Key? key,
      required this.menuItem,
      required this.dayInfo,
      required this.onAddItem})
      : super(key: key);

  String? _checkAvailability() {
    if (!menuItem.stock.available) {
      return _outOfStock;
    } else if (AvailableTimeProvider().haveAvailableTime(dayInfo) == null) {
      return _unavailable;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final availability = _checkAvailability();
    return SizedBox(
      width: AppSize.s100.rw,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: (availability == null || availability == _unavailable) ? onAddItem : null,
              child: SizedBox(
                height: AppSize.s100.rh,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  clipBehavior: Clip.none,
                  children: [
                    MenuItemImageView(
                      image: menuItem.image,
                      available: availability,
                    ),
                    Positioned(
                      bottom: 8,
                      child: Container(
                        width: AppSize.s90.rw,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.purpleBlue,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSize.s8.rw, vertical: AppSize.s2.rh),
                          child: Text(
                            OrderPriceProvider.klikitItemPrice(menuItem.prices),
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
                          color: (availability == null)
                              ? AppColors.purpleBlue
                              : AppColors.lightGrey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (availability == null || availability == _unavailable) ? onAddItem : null,
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
                    Icon(Icons.info_outline,size: AppSize.s16.rSp),
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
