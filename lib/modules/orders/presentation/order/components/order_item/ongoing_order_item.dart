import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/order_action_buttons.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/order_item_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../domain/entities/order.dart';
import '../../../../domain/entities/order_status.dart';
import '../../../bloc/orders/order_action_cubit.dart';
import '../action_dialogs.dart';

class OngoingOrderItemView extends StatelessWidget {
  final Function(Order) seeDetails;
  final VoidCallback onRefresh;
  final Order order;

  const OngoingOrderItemView(
      {Key? key, required this.order, required this.seeDetails, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OrderItemView(order: order, seeDetails: seeDetails),
            Row(
              children: [
                PrintButton(
                  onPrint: () {},
                  padding: AppSize.s16,
                ),
                SizedBox(width: AppSize.s8.rw),
                DeliverButton(
                  onDeliver: () {
                    showOrderActionDialog(
                      id: order.id,
                      status: OrderStatusId.DELIVERED,
                      context: context,
                      onSuccess: onRefresh,
                      title: 'Deliver order #${order.id}',
                      cubit: context.read<OrderActionCubit>(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const Divider(thickness: AppSize.s1),
      ],
    );
  }
}
