import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/avilable_times.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import 'menu_item_description.dart';
import 'menu_item_image_view.dart';

class MenuItemView extends StatelessWidget {
  final MenuItems menuItem;
  final DayInfo dayInfo;

  const MenuItemView({Key? key, required this.menuItem, required this.dayInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s100.rw,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
        child: Column(
          children: [
            SizedBox(
              height: AppSize.s100.rh,
              child: Stack(
                alignment: AlignmentDirectional.center,
                clipBehavior: Clip.none,
                children: [
                  MenuItemImageView(image: menuItem.image),
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
                          '290.00 PHP',
                          textAlign: TextAlign.center,
                          style: getBoldTextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -4,
                    child: IconButton(
                      enableFeedback: true,
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle,
                        color: AppColors.purpleBlue,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  )
                ],
              ),
            ),
            Padding(
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
                  IconButton(
                    onPressed: () {
                      _showItemDetails(context, menuItem);
                    },
                    icon: const Icon(Icons.info_outline),
                    iconSize: AppSize.s16.rSp,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, MenuItems item) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.s14.rSp),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: AppSize.s200.rh,
          child: MenuItemDescription(items: item),
        );
      },
    );
  }
}
