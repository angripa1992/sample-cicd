import 'package:badges/badges.dart' as bg;
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class OrderCounter extends StatelessWidget {
  final Function() onCartTap;

  const OrderCounter({Key? key, required this.onCartTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: CartManager().cartItemCountNotifier,
      builder: (_, unreadCount, __) {
        return InkWell(
          onTap: onCartTap,
          child: unreadCount > 0
              ? bg.Badge(
                  position: bg.BadgePosition.topEnd(top: -3, end: -3),
                  badgeContent: Text(
                    '$unreadCount',
                    style: mediumTextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSize.s10.rSp,
                    ),
                  ),
                  badgeStyle: bg.BadgeStyle(
                    shape: bg.BadgeShape.circle,
                    badgeColor: AppColors.primary,
                    padding: const EdgeInsets.all(4),
                    borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                  ),
                  child: _icon(),
                )
              : _icon(),
        );
      },
    );
  }

  Widget _icon() {
    return DecoratedImageView(
      iconWidget: ImageResourceResolver.cartSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh),
      padding: EdgeInsets.all(AppSize.s6.rSp),
      decoration: BoxDecoration(
        color: AppColors.neutralB20,
        borderRadius: BorderRadius.all(Radius.circular(200.rSp)),
      ),
    );
  }
}
