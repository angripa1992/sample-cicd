import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/strings.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../domain/entities/cart.dart';
import 'editing_item.dart';
import 'editing_manager.dart';

class EditGrabOrderView extends StatelessWidget {
  final Order order;
  final Order copyOrder;
  final VoidCallback onClose;

  const EditGrabOrderView({
    Key? key,
    required this.order,
    required this.onClose,
    required this.copyOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          _appBar(),
          _brandSpecificCartItemsListView(),
          _priceView(),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
        child: Row(
          children: [
            IconButton(onPressed: onClose, icon: const Icon(Icons.clear)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cart',
                  style: getMediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s17.rSp,
                  ),
                ),
                SizedBox(height: AppSize.s4.rh),
                Text(
                  '#${order.id} (Order ID)',
                  style: getRegularTextStyle(
                    color: AppColors.dustyGreay,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _brandSpecificCartItemsListView() {
    final brandSpecificCartItems = EditingManager().extractCartItems(order);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
        child: ListView.builder(
          itemCount: brandSpecificCartItems.length,
          itemBuilder: (context, index) {
            final menuBrand = brandSpecificCartItems[index].first.cartBrand;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
              margin: EdgeInsets.symmetric(vertical: AppSize.s16.rh),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: AppColors.white,
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              menuBrand.title,
                              style: getBoldTextStyle(
                                color: AppColors.balticSea,
                                fontSize: AppFontSize.s15.rSp,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Remove All',
                              style: getMediumTextStyle(
                                color: AppColors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      _cartItemListView(brandSpecificCartItems[index]),
                      const Divider(),
                      _totalOrder(),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _cartItemListView(List<CartV2> items) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return EditingItemVIew(item: item);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  Widget _totalOrder() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: AppSize.s12.rh,
        top: AppSize.s8.rh,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.total.tr(),
              style: getRegularTextStyle(
                color: AppColors.balticSea,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
          ),
          Text(
            'PHP 1324.00',
            style: getMediumTextStyle(
              color: AppColors.balticSea,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceView() {
    return Container(
      margin: EdgeInsets.only(
        left: AppSize.s12.rw,
        right: AppSize.s12.rw,
        bottom: AppSize.s16.rh,
        top: AppSize.s8.rh,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s12.rw,
        vertical: AppSize.s16.rh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          _item(title: AppStrings.sub_total.tr(), price: 12, subtotal: true),
          SizedBox(height: AppSize.s8.rh),
          _item(title: AppStrings.vat.tr(), price: 12, subtotal: false),
          SizedBox(height: AppSize.s8.rh),
          _item(
              title: AppStrings.delivery_fee.tr(), price: 12, subtotal: false),
          SizedBox(height: AppSize.s8.rh),
          _item(title: AppStrings.discount.tr(), price: 12, subtotal: false),
          SizedBox(height: AppSize.s8.rh),
          _item(
              title: AppStrings.additional_fee.tr(),
              price: 12,
              subtotal: false),
        ],
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
          'PHP $price.00',
          style: textStyle,
        ),
      ],
    );
  }

  Widget _bottomView() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s16.rh,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: AppStrings.total.tr(),
                  style: getMediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                  children: [
                    TextSpan(
                      text: ' (including VAT)',
                      style: getRegularTextStyle(
                        color: AppColors.dustyGreay,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'PHP 12.00',
                style: getMediumTextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
