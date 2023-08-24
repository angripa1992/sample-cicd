import 'package:badges/badges.dart' as bg;
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/values.dart';
import '../../../utils/cart_manager.dart';

class CartBadge extends StatelessWidget {
  final Color? iconColor;
  final VoidCallback onCartTap;

  const CartBadge({Key? key, required this.onCartTap, this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CartManager().cartItemNotifier(),
      builder: (_, count, __) {
        return InkWell(
          onTap: onCartTap,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: AppSize.s20.rw,
            ),
            child: count > 0
                ? bg.Badge(
                    position: bg.BadgePosition.topEnd(top: -16, end: -8),
                    badgeContent: Text(
                      '$count',
                      style: mediumTextStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.s10.rSp,
                      ),
                    ),
                    badgeStyle: bg.BadgeStyle(
                      shape: bg.BadgeShape.circle,
                      badgeColor: AppColors.red,
                      padding: const EdgeInsets.all(5),
                      borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                    ),
                    child: Icon(
                      Icons.add_shopping_cart,
                      color: iconColor ?? AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.add_shopping_cart,
                    color: iconColor ?? AppColors.primary,
                  ),
          ),
        );
      },
    );
  }
}
