import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/core/widgets/kt_tooltip.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';

import '../../../../../../app/di.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../common/business_information_provider.dart';
import '../../../../../common/entities/branch.dart';
import '../../../../utils/cart_manager.dart';

class CartPriceView extends StatelessWidget {
  final CartBill cartBill;
  final VoidCallback onDeliveryFee;
  final VoidCallback onDiscount;
  final VoidCallback onAdditionalFee;
  final Function(bool) onApplyRoundOff;

  const CartPriceView({
    Key? key,
    required this.cartBill,
    required this.onDeliveryFee,
    required this.onDiscount,
    required this.onAdditionalFee,
    required this.onApplyRoundOff,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, bottom: AppSize.s8.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw, vertical: AppSize.s8.rh),
        child: Column(
          children: [
            _item(
              title: AppStrings.sub_total.tr(),
              price: cartBill.subTotal,
              subtotal: true,
            ),
            _item(
              title: AppStrings.vat.tr(),
              price: cartBill.vatPrice,
            ),
            _item(
              title: AppStrings.restaurant_service_fee.tr(),
              price: cartBill.restaurantServiceFee,
            ),
            CartManager().isWebShopOrder
                ? _item(
                    title: AppStrings.delivery_fee.tr(),
                    price: cartBill.deliveryFee,
                  )
                : _editableItem(
                    title: AppStrings.delivery_fee.tr(),
                    price: cartBill.deliveryFee,
                    onTap: onDeliveryFee,
                  ),
            if (CartManager().isWebShopOrder && cartBill.rewardPrice > 0)
              _item(
                title: 'Reward Discount',
                price: cartBill.rewardPrice,
              ),
            _editableItem(
              title: AppStrings.discount.tr(),
              price: cartBill.discountAmount,
              onTap: onDiscount,
            ),
            if (!CartManager().isWebShopOrder)
              _editableItem(
                title: AppStrings.additional_fee.tr(),
                price: cartBill.additionalFee,
                onTap: onAdditionalFee,
              ),
            if (CartManager().isWebShopOrder)
              _item(
                title: AppStrings.processing_fee.tr(),
                price: 0,
                willCalculateAtNextStep: true,
              ),
            if (CartManager().isWebShopOrder && cartBill.customFee > 0)
              FutureBuilder<Branch?>(
                future: getIt.get<BusinessInformationProvider>().branchByID(SessionManager().branchId()),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return _item(
                      title: snapshot.data!.webshopCustomFeesTitle,
                      price: cartBill.customFee,
                    );
                  }
                  return Container();
                },
              ),
            if (!CartManager().isWebShopOrder) _roundOffView(),
          ],
        ),
      ),
    );
  }

  Widget _roundOffView() {
    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            Text(
              AppStrings.round_off.tr(),
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: 14.rSp,
              ),
            ),
            8.horizontalSpacer(),
            KTTooltip(message: AppStrings.round_off_tooltip.tr()),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw, vertical: AppSize.s4.rh),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                color: cartBill.roundOffAmount != 0 ? AppColors.grey : AppColors.primaryLighter,
              ),
              child: cartBill.roundOffAmount != 0
                  ? Row(
                      children: [
                        Text(
                          '${CartManager().currency.symbol} ${cartBill.roundOffAmount.isNegative ? '' : '+'}${cartBill.roundOffAmount}',
                          style: regularTextStyle(color: AppColors.black, fontSize: 14.rSp),
                        ),
                        SizedBox(width: 4.rw),
                        InkWell(
                          onTap: () {
                            onApplyRoundOff(false);
                          },
                          child: Icon(Icons.clear, size: 14.rSp),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        onApplyRoundOff(true);
                      },
                      child: Text(
                        'Apply',
                        style: regularTextStyle(color: AppColors.primary, fontSize: 14.rSp),
                      ),
                    ),
            ),
          ],
        )
      ],
    );
  }

  Widget _item({
    required String title,
    required num price,
    subtotal = false,
    willCalculateAtNextStep = false,
  }) {
    final textStyle = TextStyle(
      color: AppColors.black,
      fontSize: subtotal ? AppFontSize.s16.rSp : AppFontSize.s14.rSp,
      fontWeight: subtotal ? FontWeight.w500 : FontWeight.w400,
    );
    final currency = CartManager().currency;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.s8.rh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textStyle,
          ),
          Text(
            willCalculateAtNextStep
                ? AppStrings.calculated_at_next_step.tr()
                : PriceCalculator.formatPrice(
                    price: price,
                    code: currency.code ?? EMPTY,
                    symbol: currency.symbol ?? EMPTY,
                  ),
            style: textStyle,
          ),
        ],
      ),
    );
  }

  Widget _editableItem({
    required String title,
    required num price,
    required VoidCallback onTap,
  }) {
    final currency = CartManager().currency;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.s8.rh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: price > 0
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                      color: AppColors.grey,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.s8.rw,
                        vertical: AppSize.s2.rh,
                      ),
                      child: Row(
                        children: [
                          Text(
                            PriceCalculator.formatPrice(
                              price: price,
                              code: currency.code ?? EMPTY,
                              symbol: currency.symbol ?? EMPTY,
                            ),
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: AppFontSize.s14.rSp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: AppSize.s8.rw),
                          Icon(
                            Icons.mode_edit_outlined,
                            size: AppSize.s16.rSp,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                    ),
                  )
                : _addView(),
          ),
        ],
      ),
    );
  }

  Widget _addView() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
        vertical: AppSize.s2.rh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s16.rSp),
        color: AppColors.primaryLighter,
      ),
      child: Row(
        children: [
          Icon(Icons.add, color: AppColors.primary, size: AppSize.s14.rSp),
          SizedBox(width: AppSize.s4.rw),
          Text(
            AppStrings.add.tr(),
            style: regularTextStyle(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
