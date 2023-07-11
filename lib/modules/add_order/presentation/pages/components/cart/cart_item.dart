import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
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
import '../../../../domain/entities/billing_response.dart';
import '../promo/item_level_sc_discount_dialog.dart';

class CartItemView extends StatelessWidget {
  final ItemBill itemBill;
  final VoidCallback onEdit;
  final AddToCartItem cartItem;
  final Function(AddToCartItem) addDiscount;
  final Function(AddToCartItem) onDelete;
  final Function(int, int) onQuantityChanged;
  final VoidCallback onCitizenDiscount;

  const CartItemView({
    Key? key,
    required this.cartItem,
    required this.onEdit,
    required this.addDiscount,
    required this.onDelete,
    required this.onQuantityChanged,
    required this.itemBill,
    required this.onCitizenDiscount,
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
                              style: mediumTextStyle(
                                color: AppColors.bluewood,
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
                                price: itemBill.discountedItemPrice *
                                    cartItem.quantity,
                                currencySymbol: cartItem.itemPrice.symbol,
                                code: cartItem.itemPrice.code,
                              ),
                              style: TextStyle(
                                color: AppColors.bluewood,
                                fontSize: AppFontSize.s14.rSp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          if (haveDiscount) SizedBox(width: AppSize.s8.rw),
                          Text(
                            PriceCalculator.formatPrice(
                              price: itemBill.itemPrice * cartItem.quantity,
                              currencySymbol: cartItem.itemPrice.symbol,
                              code: cartItem.itemPrice.code,
                            ),
                            style: TextStyle(
                              color: haveDiscount
                                  ? AppColors.red
                                  : AppColors.bluewood,
                              fontSize: AppFontSize.s14.rSp,
                              fontWeight: FontWeight.w400,
                              decoration: haveDiscount
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
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
                                    : 0,
                              ),
                              child: Text(
                                snapShot.data!,
                                style: regularTextStyle(
                                  color: AppColors.smokeyGrey,
                                ),
                              ),
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
        _actionButtons(),
        _buildScDiscountButton(),
        const Divider(),
      ],
    );
  }

  TextButton _buildScDiscountButton() {
    return TextButton(
      onPressed: onCitizenDiscount,
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.discount,
            height: AppSize.s18.rh,
            width: AppSize.s18.rw,
          ),
          SizedBox(width: AppSize.s8.rw),
          Text(
            'Add SC Discount',
            style: mediumTextStyle(
              color: AppColors.purpleBlue,
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
        _outlineButton(
          text: AppStrings.discount.tr(),
          icon: itemBill.discount > 0 ? Icons.edit : Icons.add,
          enabled: true,
          onPressed: () {
            addDiscount(cartItem);
          },
        ),
        const Spacer(),
        CounterView(
          count: cartItem.quantity,
          minCount: 1,
          onChanged: (quantity) {
            onQuantityChanged(cartItem.item.id, quantity);
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
          color: enabled ? AppColors.purpleBlue : AppColors.dustyGreay,
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
              color: enabled ? AppColors.purpleBlue : AppColors.dustyGreay,
              size: AppSize.s14.rSp,
            ),
          if (icon != null) SizedBox(width: AppSize.s4.rw),
          Text(
            text,
            style: mediumTextStyle(
              color: enabled ? AppColors.purpleBlue : AppColors.dustyGreay,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ],
      ),
    );
  }
}
