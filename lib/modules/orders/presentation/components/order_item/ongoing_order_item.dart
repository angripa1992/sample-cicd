import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/values.dart';

import '../../../domain/entities/order.dart';
import 'order_action_buttons.dart';
import 'order_item_view.dart';

class OngoingOrderItemView extends StatelessWidget {
  final VoidCallback seeDetails;
  final Function(String, int) onAction;
  final Function(String) onCancel;
  final VoidCallback onPrint;
  final VoidCallback onEditGrabOrder;
  final VoidCallback onEditManualOrder;
  final Order order;

  const OngoingOrderItemView({
    Key? key,
    required this.order,
    required this.seeDetails,
    required this.onAction,
    required this.onPrint,
    required this.onCancel,
    required this.onEditGrabOrder,
    required this.onEditManualOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OrderItemView(order: order, seeDetails: seeDetails),
            ),
            Padding(
              padding: EdgeInsets.only(right: AppSize.s2.rw),
              child: getActionButtons(
                order: order,
                onAction: onAction,
                onPrint: onPrint,
                onCancel: onCancel,
                onEditGrabOrder: onEditGrabOrder,
                onEditManualOrder: onEditManualOrder,
              ),
            ),
          ],
        ),
        const Divider(thickness: AppSize.s1),
      ],
    );
  }
}
