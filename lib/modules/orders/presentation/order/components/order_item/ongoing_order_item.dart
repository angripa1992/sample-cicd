import 'package:flutter/material.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/order_action_buttons.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/order_item_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../domain/entities/order.dart';

class OngoingOrderItemView extends StatelessWidget {
  final VoidCallback seeDetails;
  final Function(String) onAction;
  final Function(String) onCancel;
  final VoidCallback onPrint;
  final Order order;

  const OngoingOrderItemView({
    Key? key,
    required this.order,
    required this.seeDetails,
    required this.onAction,
    required this.onPrint, required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrderItemView(order: order, seeDetails: seeDetails),
            getActionButtons(
              order: order,
              onAction: onAction,
              onPrint: onPrint,
              onCancel: onCancel,
            ),
          ],
        ),
        const Divider(thickness: AppSize.s1),
      ],
    );
  }
}
