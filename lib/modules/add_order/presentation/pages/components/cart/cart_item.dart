import 'package:flutter/material.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/utils/modifier_manager.dart';

class CartItemView extends StatelessWidget {
  final VoidCallback onEdit;
  final AddToCartItem cartItem;

  const CartItemView({Key? key, required this.cartItem, required this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${cartItem.quantity}x ${cartItem.item.title}'),
        FutureBuilder<String>(
          future: ModifierManager().allCsvModifiersName(cartItem.modifiers),
          builder: (context, snapShot) {
            if(snapShot.hasData){
              return Text(snapShot.data!);
            }
            return const SizedBox();
          },
        ),
        ElevatedButton(onPressed: onEdit, child: Text('Edit')),
      ],
    );
  }
}
