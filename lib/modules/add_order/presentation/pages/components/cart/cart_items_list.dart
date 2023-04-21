import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/brand.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../../../../utils/cart_manager.dart';
import 'cart_item.dart';
import 'cart_item_brand.dart';
import 'cart_price_view.dart';

class CartItemsListView extends StatelessWidget {
  final CartBill cartBill;
  final VoidCallback onDeliveryFee;
  final VoidCallback onDiscount;
  final VoidCallback onAdditionalFee;
  final Function(AddToCartItem) onEdit;
  final Function(MenuBrand) addMore;
  final Function(AddToCartItem) addDiscount;
  final Function(AddToCartItem) onDelete;
  final Function(int, int) onQuantityChanged;
  final Function(int) removeAll;

  const CartItemsListView({
    Key? key,
    required this.cartBill,
    required this.onDeliveryFee,
    required this.onDiscount,
    required this.onAdditionalFee,
    required this.onEdit,
    required this.addMore,
    required this.addDiscount,
    required this.onDelete,
    required this.onQuantityChanged,
    required this.removeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartsItemByBrands = CartManager().cartItemsMapWithBrands();
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartsItemByBrands.length,
          itemBuilder: (context, index) {
            final cartItems = cartsItemByBrands[index];
            return Container(
              margin: EdgeInsets.only(
                left: AppSize.s16.rw,
                right: AppSize.s16.rw,
                bottom: AppSize.s8.rw,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppSize.s8.rSp,
                ),
                color: AppColors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CartItemBrand(
                    menuBrand: cartItems.first.brand,
                    removeAll: removeAll,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                    child: Column(
                      children: cartItems.map(
                        (cartItem) {
                          return CartItemView(
                            cartItem: cartItem,
                            onEdit: () {
                              onEdit(cartItem);
                            },
                            addDiscount: addDiscount,
                            onDelete: onDelete,
                            onQuantityChanged: onQuantityChanged,
                            itemBill: cartBill.items.firstWhere((element) => element.id == cartItem.item.id),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s12.rw,
                    ),
                    child: TextButton(
                      onPressed: () {
                        addMore(cartItems.first.brand);
                      },
                      child: Text(
                        '+ Add more items',
                        style: getMediumTextStyle(
                          color: AppColors.purpleBlue,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        CartPriceView(
          cartBill: cartBill,
          onDeliveryFee: onDeliveryFee,
          onAdditionalFee: onAdditionalFee,
          onDiscount: onDiscount,
        ),
      ],
    );
  }
}
