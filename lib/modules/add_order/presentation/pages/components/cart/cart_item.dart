import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/utils/modifier_manager.dart';

import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/menu_item_image_view.dart';
import '../../../../domain/entities/billing_response.dart';
import '../modifier/quantity_selector.dart';

class CartItemView extends StatelessWidget {
  final ItemBill itemBill;
  final VoidCallback onEdit;
  final AddToCartItem cartItem;
  final Function(AddToCartItem) addDiscount;
  final Function(AddToCartItem) onDelete;
  final Function(int, int) onQuantityChanged;

  const CartItemView({
    Key? key,
    required this.cartItem,
    required this.onEdit,
    required this.addDiscount,
    required this.onDelete,
    required this.onQuantityChanged,
    required this.itemBill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final haveDiscount = itemBill.discountedItemPrice != itemBill.itemPrice;
    return Column(
      children: [
        InkWell(
          onTap: cartItem.modifiers.isEmpty ? null : onEdit,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
            child: Row(
              children: [
                MenuItemImageView(url: cartItem.item.image),
                SizedBox(width: AppSize.s16.rw),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${cartItem.quantity}x ${cartItem.item.title}',
                              style: getMediumTextStyle(
                                color: AppColors.purpleBlue,
                                fontSize: AppFontSize.s14.rSp,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSize.s16.rw),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (haveDiscount)
                                Text(
                                  PriceCalculator.formatPrice(
                                    price: itemBill.discountedItemPrice *
                                        cartItem.quantity,
                                    currencySymbol: cartItem.itemPrice.symbol,
                                    code: cartItem.itemPrice.code,
                                  ),
                                  style: TextStyle(
                                    color: AppColors.balticSea,
                                    fontSize: AppFontSize.s14.rSp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              Text(
                                PriceCalculator.formatPrice(
                                  price: itemBill.itemPrice * cartItem.quantity,
                                  currencySymbol: cartItem.itemPrice.symbol,
                                  code: cartItem.itemPrice.code,
                                ),
                                style: TextStyle(
                                  color: haveDiscount
                                      ? AppColors.red
                                      : AppColors.balticSea,
                                  fontSize: AppFontSize.s14.rSp,
                                  fontWeight: FontWeight.w500,
                                  decoration: haveDiscount
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      FutureBuilder<String>(
                        future: ModifierManager()
                            .allCsvModifiersName(cartItem.modifiers),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: snapShot.data!.isNotEmpty
                                      ? AppSize.s8.rh
                                      : 0),
                              child: Text(snapShot.data!),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: cartItem.modifiers.isEmpty
                      ? AppColors.dustyGreay
                      : AppColors.purpleBlue,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s20.rSp),
                ),
              ),
              onPressed: cartItem.modifiers.isEmpty ? null : onEdit,
              child: Text(
                AppStrings.edit,
                style: getRegularTextStyle(
                  color: cartItem.modifiers.isEmpty
                      ? AppColors.dustyGreay
                      : AppColors.purpleBlue,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
            SizedBox(width: AppSize.s8.rw),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.purpleBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s20.rSp),
                ),
              ),
              onPressed: () {
                addDiscount(cartItem);
              },
              child: Row(
                children: [
                  Icon(
                    itemBill.discount > 0 ? Icons.edit : Icons.add,
                    color: AppColors.purpleBlue,
                    size: AppSize.s14.rSp,
                  ),
                  SizedBox(width: AppSize.s4.rw),
                  Text(
                    AppStrings.discount.tr(),
                    style: getRegularTextStyle(
                      color: AppColors.purpleBlue,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSize.s8.rw),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => onDelete(cartItem),
              icon: Icon(
                Icons.delete_outline,
                color: AppColors.red,
              ),
            ),
            const Spacer(),
            QuantitySelector(
              quantity: cartItem.quantity,
              onQuantityChanged: (quantity) {
                onQuantityChanged(cartItem.item.id, quantity);
              },
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
