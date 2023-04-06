import 'package:flutter/material.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import 'cart_app_bar.dart';
import 'cart_item.dart';

class CartScreen extends StatelessWidget {
  final VoidCallback onClose;
  final Function(AddToCartItem) onEdit;
  const CartScreen({Key? key, required this.onClose, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          CartAppBar(onClose: onClose),
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
                    return Column(
                      children: [
                        Text(cartItems.first.brand!.title),
                        Divider(),
                        Column(
                          children: cartItems.map((cartItem) {
                            return CartItemView(
                              cartItem: cartItem,
                              onEdit: () {
                                onEdit(cartItem);
                              },
                            );
                          }).toList(),
                        )
                      ],
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
