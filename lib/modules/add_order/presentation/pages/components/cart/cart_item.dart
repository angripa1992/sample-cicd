import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/core/widgets/kt_counter.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/add_order/utils/modifier_manager.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

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
    if (itemBill == null) return const SizedBox();
    return Column(
      children: [
        InkWell(
          onTap: cartItem.modifiers.isEmpty ? null : onEdit,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.rh),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              cartItem.item.title,
                              style: mediumTextStyle(
                                color: AppColors.black,
                                fontSize: 14.rSp,
                              ),
                            ),
                          ),
                          SizedBox(width: 24.rw),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => onDelete(cartItem),
                            icon: SvgPicture.asset(AppIcons.delete, height: 18.rh, width: 18.rw),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.rh),
                      _itemPriceView(),
                      _modifierNames(),
                      CartItemNoteView(cartItem: cartItem),
                      if (cartItem.promoInfo != null) _appliedPromoView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.rh),
        _actionButtons(),
        Padding(
          padding: EdgeInsets.only(top: 8.rh),
          child: const Divider(),
        ),
      ],
    );
  }

  Widget _itemPriceView() {
    final haveDiscount = itemBill!.discountedItemPrice != itemBill!.itemPrice;
    return Row(
      children: [
        if (haveDiscount)
          Text(
            PriceCalculator.formatPrice(
              price: itemBill!.discountedItemPrice * itemBill!.quantity,
              code: cartItem.itemPrice.currencyCode,
              symbol: cartItem.itemPrice.currencySymbol,
            ),
            style: TextStyle(
              color: AppColors.neutralB700,
              fontSize: 14.rSp,
              fontWeight: FontWeight.w400,
            ),
          ),
        if (haveDiscount) SizedBox(width: 8.rw),
        Text(
          PriceCalculator.formatPrice(
            price: itemBill!.itemPrice * itemBill!.quantity,
            code: cartItem.itemPrice.currencyCode,
            symbol: cartItem.itemPrice.currencySymbol,
          ),
          style: TextStyle(
            color: haveDiscount ? AppColors.red : AppColors.neutralB700,
            fontSize: 14.rSp,
            fontWeight: FontWeight.w400,
            decoration: haveDiscount ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _modifierNames() {
    return FutureBuilder<String>(
      future: ModifierManager().allCsvModifiersName(cartItem.modifiers),
      builder: (context, snapShot) {
        if (snapShot.hasData && snapShot.data.isNotNullOrEmpty()) {
          return Padding(
            padding: EdgeInsets.only(top: snapShot.data!.isNotEmpty ? 8.rh : 0),
            child: Text(
              snapShot.data!,
              style: regularTextStyle(color: AppColors.neutralB100, fontSize: 13.rSp),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _appliedPromoView() {
    return Container(
      margin: EdgeInsets.only(top: 10.rh),
      padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.rSp),
        border: Border.all(color: AppColors.neutralB40),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.discount),
          SizedBox(width: 8.rw),
          Expanded(
            child: Text(
              cartItem.promoInfo?.promo?.code ?? '',
              style: mediumTextStyle(color: AppColors.black, fontSize: 14.rSp),
            ),
          ),
          if (cartItem.promoInfo?.promo?.isSeniorCitizenPromo ?? false)
            Text(
              '${cartItem.promoInfo?.numberOfSeniorCitizen} ${AppStrings.pieces.tr()}',
              style: mediumTextStyle(color: AppColors.black, fontSize: 14.rSp),
            ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      children: [
        if (cartItem.modifiers.isNotEmpty) _outlineButton(onPressed: onEdit, text: AppStrings.edit.tr()),
        if (cartItem.modifiers.isNotEmpty) SizedBox(width: 8.rw),
        Visibility(
          visible: !CartManager().isWebShopOrder,
          child: _outlineButton(
            text: AppStrings.discount.tr(),
            icon: itemBill!.discount > 0 ? Icons.edit : Icons.add,
            onPressed: () {
              addDiscount(cartItem);
            },
          ),
        ),
        const Spacer(),
        KTCounter(
          count: cartItem.quantity,
          minCount: 1,
          activeStrokeColor: AppColors.primaryP300,
          onChanged: (quantity) {
            onQuantityChanged(cartItem, quantity);
          },
        ),
      ],
    );
  }

  Widget _outlineButton({
    IconData? icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 4.rh),
        decoration: BoxDecoration(
          color: AppColors.neutralB20,
          borderRadius: BorderRadius.circular(16.rSp),
          border: Border.all(color: AppColors.neutralB40),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon, color: AppColors.neutralB700, size: 18.rSp),
            if (icon != null) SizedBox(width: 4.rw),
            Text(
              text,
              style: mediumTextStyle(color: AppColors.neutralB700, fontSize: 14.rSp),
            ),
          ],
        ),
      ),
    );
  }
}
