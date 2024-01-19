import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/resources/colors.dart';
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
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s4.rw),
                child: DecoratedImageView(
                  iconWidget: ImageResourceResolver.cartSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh),
                  padding: EdgeInsets.all(AppSize.s6.rSp),
                  decoration: BoxDecoration(
                    color: AppColors.neutralB20,
                    borderRadius: BorderRadius.all(
                      Radius.circular(200.rSp),
                    ),
                  ),
                ),
              ),
              if (unreadCount > 0)
                KTChip(
                  text: '$unreadCount',
                  textStyle: boldTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.white),
                  backgroundColor: AppColors.primaryP300,
                  strokeColor: AppColors.white,
                  strokeWidth: AppSize.s2.rSp,
                  padding: EdgeInsets.fromLTRB(
                    unreadCount < 10 ? AppSize.s8.rw : AppSize.s6.rw,
                    AppSize.s4.rh,
                    unreadCount < 10 ? AppSize.s8.rw : AppSize.s6.rw,
                    AppSize.s4.rh,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
