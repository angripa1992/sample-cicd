import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../utils/cart_manager.dart';

class CartPriceView extends StatelessWidget {
  final CartBill cartBill;
  final VoidCallback onDeliveryFee;
  final VoidCallback onDiscount;
  final VoidCallback onAdditionalFee;

  const CartPriceView({
    Key? key,
    required this.cartBill,
    required this.onDeliveryFee,
    required this.onDiscount,
    required this.onAdditionalFee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: AppSize.s16.rw,
        right: AppSize.s16.rw,
        bottom: AppSize.s8.rw,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s12.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          children: [
            _item(
              title: AppStrings.sub_total.tr(),
              price: cartBill.subTotal,
              subtotal: true,
            ),
            SizedBox(height: AppSize.s12.rh),
            _item(
              title: AppStrings.vat.tr(),
              price: cartBill.vatPrice,
            ),
            SizedBox(height: AppSize.s12.rh),
            _editableItem(
              title: AppStrings.delivery_fee.tr(),
              price: cartBill.deliveryFee,
              onTap: onDeliveryFee,
            ),
            SizedBox(height: AppSize.s12.rh),
            _editableItem(
              title: AppStrings.discount.tr(),
              price: cartBill.discountAmount,
              onTap: onDiscount,
            ),
            SizedBox(height: AppSize.s12.rh),
            _editableItem(
              title: AppStrings.additional_fee.tr(),
              price: cartBill.additionalFee,
              onTap: onAdditionalFee,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({
    required String title,
    required num price,
    bool subtotal = false,
  }) {
    final textStyle = TextStyle(
      color: AppColors.balticSea,
      fontSize: subtotal ? AppFontSize.s16.rSp : AppFontSize.s14.rSp,
      fontWeight: subtotal ? FontWeight.w500 : FontWeight.w400,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        Text(
          '${CartManager().currency().symbol} $price',
          style: textStyle,
        ),
      ],
    );
  }

  Widget _editableItem({
    required String title,
    required num price,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: getRegularTextStyle(
            color: AppColors.balticSea,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              color: AppColors.whiteSmoke,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s8.rw,
                vertical: AppSize.s2.rh,
              ),
              child: Row(
                children: [
                  Text(
                    '${CartManager().currency().symbol} $price',
                    style: TextStyle(
                      color: AppColors.balticSea,
                      fontSize: AppFontSize.s14.rSp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: AppSize.s8.rw),
                  Icon(
                    Icons.mode_edit_outlined,
                    size: AppSize.s16.rSp,
                    color: AppColors.balticSea,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
