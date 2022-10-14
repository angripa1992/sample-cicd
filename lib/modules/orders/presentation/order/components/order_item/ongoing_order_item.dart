import 'package:flutter/material.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/order_item_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../domain/entities/order.dart';

class OngoingOrderItemView extends StatelessWidget {
  final Function(Order) seeDetails;
  final Order order;

  const OngoingOrderItemView({Key? key, required this.order, required this.seeDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrderItemView(order: order,seeDetails: seeDetails),
        const Divider(thickness: AppSize.s1),
      ],
    );
  }
}
