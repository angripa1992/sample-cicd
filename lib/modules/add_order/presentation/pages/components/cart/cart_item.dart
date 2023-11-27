import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/add_order/utils/modifier_manager.dart';

import '../../../../../../core/utils/price_calculator.dart';
import '../../../../../../resources/assets.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/counter_view.dart';
import '../../../../../widgets/menu_item_image_view.dart';
import '../../../../domain/entities/cart_bill.dart';
import 'cart_item_note_view.dart';

class CartItemView extends StatelessWidget {
  final ItemBill? itemBill;
  final VoidCallback onEdit;
  final AddToCartItem cartItem;
  final Function(AddToCartItem) addDiscount;
  final Function(AddToCartItem) onDelete;
  final Function(AddToCartItem, int) onQuantityChanged;

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
    if(itemBill == null) return const SizedBox();
    final haveDiscount = itemBill!.discountedItemPrice != itemBill!.itemPrice;
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
                              '${itemBill!.quantity}x ${cartItem.item.title}',
                              style: mediumTextStyle(
                                color: AppColors.black,
                                fontSize: AppFontSize.s16.rSp,
                              ),
                            ),
                          ),
                          SizedBox(width: AppSize.s16.rw),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => onDelete(cartItem),
                            icon: SvgPicture.asset(
                              AppIcons.delete,
                              height: AppSize.s18.rh,
                              width: AppSize.s18.rw,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.s2.rh),
                      Row(
                        children: [
                          if (haveDiscount)
                            Text(
                              PriceCalculator.formatPrice(
                                price: itemBill!.discountedItemPrice * itemBill!.quantity,
                                code: cartItem.itemPrice.currencyCode,
                                symbol: cartItem.itemPrice.currencySymbol,
                              ),
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: AppFontSize.s14.rSp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          if (haveDiscount) SizedBox(width: AppSize.s8.rw),
                          Text(
                            PriceCalculator.formatPrice(
                              price: itemBill!.itemPrice * itemBill!.quantity,
                              code: cartItem.itemPrice.currencyCode,
                              symbol: cartItem.itemPrice.currencySymbol,
                            ),
                            style: TextStyle(
                              color: haveDiscount ? AppColors.red : AppColors.black,
                              fontSize: AppFontSize.s14.rSp,
                              fontWeight: FontWeight.w400,
                              decoration: haveDiscount ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      FutureBuilder<String>(
                        future: ModifierManager().allCsvModifiersName(cartItem.modifiers),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: snapShot.data!.isNotEmpty ? AppSize.s8.rh : 0,
                              ),
                              child: Text(
                                snapShot.data!,
                                style: regularTextStyle(
                                  color: AppColors.greyDarker,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      CartItemNoteView(cartItem: cartItem),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _actionButtons(),
        if (cartItem.promoInfo != null) _appliedPromoView(),
        const Divider(),
      ],
    );
  }

  Widget _appliedPromoView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s8.rh,
        horizontal: AppSize.s8.rw,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.grey,
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.discount),
          SizedBox(width: AppSize.s8.rw),
          Expanded(
            child: Text(
              cartItem.promoInfo?.promo?.code ?? '',
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ),
          if (cartItem.promoInfo?.promo?.isSeniorCitizenPromo ?? false)
            Text(
              '${cartItem.promoInfo?.numberOfSeniorCitizen} ${AppStrings.pieces.tr()}',
              style: mediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        _outlineButton(
          onPressed: onEdit,
          text: AppStrings.edit.tr(),
          enabled: cartItem.modifiers.isNotEmpty,
        ),
        SizedBox(width: AppSize.s8.rw),
        Visibility(
          visible: !CartManager().isWebShopOrder,
          child: _outlineButton(
            text: AppStrings.discount.tr(),
            icon: itemBill!.discount > 0 ? Icons.edit : Icons.add,
            enabled: true,
            onPressed: () {
              addDiscount(cartItem);
            },
          ),
        ),
        const Spacer(),
        CounterView(
          count: cartItem.quantity,
          minCount: 1,
          onChanged: (quantity) {
            onQuantityChanged(cartItem, quantity);
          },
          enabled: true,
        ),
      ],
    );
  }

  Widget _outlineButton({
    IconData? icon,
    required String text,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s4.rh,
        ),
        side: BorderSide(
          color: enabled ? AppColors.primary : AppColors.greyDarker,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        ),
      ),
      onPressed: enabled ? onPressed : null,
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: enabled ? AppColors.primary : AppColors.greyDarker,
              size: AppSize.s14.rSp,
            ),
          if (icon != null) SizedBox(width: AppSize.s4.rw),
          Text(
            text,
            style: mediumTextStyle(
              color: enabled ? AppColors.primary : AppColors.greyDarker,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ],
      ),
    );
  }
}
