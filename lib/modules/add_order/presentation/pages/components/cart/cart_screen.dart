import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/step_view.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/brand.dart';
import 'cart_app_bar.dart';
import 'cart_item.dart';
import 'cart_item_brand.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onClose;
  final Function(AddToCartItem) onEdit;
  final Function(MenuBrand) addMore;

  const CartScreen({
    Key? key,
    required this.onClose,
    required this.onEdit,
    required this.addMore,
  }) : super(key: key);

  void _removeAll(int brandId) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          CartAppBar(onClose: onClose),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s10.rw,
              vertical: AppSize.s16.rh,
            ),
            child: const StepView(stepPosition: StepPosition.cart),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: CartManager().getNotifyListener(),
              builder: (_, value, __) {
                final cartsItemByBrands =
                    CartManager().cartItemsMapWithBrands();
                return ListView.builder(
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
                        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                        color: AppColors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CartItemBrand(
                            menuBrand: cartItems.first.brand,
                            removeAll: _removeAll,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSize.s12.rw),
                            child: Column(
                              children: cartItems.map((cartItem) {
                                return CartItemView(
                                  cartItem: cartItem,
                                  onEdit: () {
                                    onEdit(cartItem);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSize.s12.rw),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
