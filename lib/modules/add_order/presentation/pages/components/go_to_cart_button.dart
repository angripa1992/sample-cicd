import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../utils/cart_manager.dart';

class GoToCartButton extends StatelessWidget {
  final VoidCallback onGotoCart;
  const GoToCartButton({Key? key, required this.onGotoCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: CartManager().getNotifyListener(),
        builder: (_, value, __) {
          final priceMap = CartManager().totalPrice();
          if (value < 1) {
            return const SizedBox();
          } else {
            return InkWell(
              onTap: onGotoCart,
              child: Container(
                margin: EdgeInsets.only(
                  left: AppSize.s8.rw,
                  right: AppSize.s8.rw,
                  bottom: AppSize.s4.rh,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  color: AppColors.purpleBlue,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s12.rw,
                    vertical: AppSize.s8.rh,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$value item(s)',
                            style: getRegularTextStyle(color: AppColors.white),
                          ),
                          SizedBox(height: AppSize.s2.rh),
                          Text(
                            '${priceMap['symbol']} ${priceMap['price']}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: AppFontSize.s16.rSp,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            'Goto Cart',
                            style: getMediumTextStyle(
                              color: AppColors.white,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                          Icon(Icons.arrow_right, color: AppColors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
