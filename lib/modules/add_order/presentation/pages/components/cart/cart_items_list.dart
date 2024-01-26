import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';
import 'package:klikit/modules/common/entities/brand.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/add_to_cart_item.dart';
import '../../../../utils/cart_manager.dart';
import '../modifier/speacial_instruction.dart';
import 'cart_item.dart';
import 'cart_item_brand.dart';
import 'cart_price_view.dart';

class CartItemsListView extends StatelessWidget {
  final CartBill cartBill;
  final TextEditingController textController;
  final VoidCallback onDeliveryFee;
  final VoidCallback onDiscount;
  final VoidCallback onAdditionalFee;
  final Function(AddToCartItem) onEdit;
  final Function(Brand) addMore;
  final Function(AddToCartItem) addDiscount;
  final Function(AddToCartItem) onDelete;
  final Function(AddToCartItem, int) onQuantityChanged;
  final Function(bool roundOffApplicable) onApplyRoundOff;
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
    required this.textController,
    required this.onApplyRoundOff,
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
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
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
                            itemBill: CartManager().findItemBill(cartBill.items, cartItem),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.s16.rw,
                    ),
                    child: TextButton(
                      onPressed: () {
                        addMore(cartItems.first.brand);
                      },
                      child: Text(
                        '+ ${AppStrings.add_more_items.tr()}',
                        style: semiBoldTextStyle(
                          color: AppColors.primary,
                          fontSize: 14.rSp,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        Divider(color: AppColors.grey,thickness: 8.rh),
        SpecialInstructionField(controller: textController),
        Divider(color: AppColors.grey,thickness: 8.rh),
        CartPriceView(
          cartBill: cartBill,
          onDeliveryFee: onDeliveryFee,
          onAdditionalFee: onAdditionalFee,
          onDiscount: onDiscount,
          onApplyRoundOff: onApplyRoundOff,
        ),
      ],
    );
  }
}
