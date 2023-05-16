import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/values.dart';

import '../../../domain/entities/order.dart';
import 'order_action_buttons.dart';
import 'order_item_view.dart';

class HistoryOrderItemView extends StatelessWidget {
  final Order order;
  final VoidCallback seeDetails;
  final VoidCallback onPrint;

  const HistoryOrderItemView(
      {Key? key,
      required this.order,
      required this.seeDetails,
      required this.onPrint})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OrderItemView(
                order: order,
                seeDetails: seeDetails,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: AppSize.s2.rw),
              child: PrintButton(
                expanded: false,
                onPrint: onPrint,
              ),
            ),
          ],
        ),
        const Divider(thickness: AppSize.s1),
      ],
    );
  }
}
