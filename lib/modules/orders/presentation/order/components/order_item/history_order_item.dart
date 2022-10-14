import 'package:flutter/material.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/order_item_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../domain/entities/order.dart';
import 'order_action_buttons.dart';

class HistoryOrderItemView extends StatelessWidget {
  final Order order;
  final Function(Order) seeDetails;

  const HistoryOrderItemView(
      {Key? key, required this.order, required this.seeDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrderItemView(
              order: order,
              seeDetails: (order) {
                seeDetails(order);
              },
            ),
            PrintButton(
              () {},
            ),
          ],
        ),
        const Divider(thickness: AppSize.s1),
      ],
    );
  }
}
