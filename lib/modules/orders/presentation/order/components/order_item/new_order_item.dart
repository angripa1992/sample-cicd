import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order_status.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/order_action_cubit.dart';
import 'package:klikit/modules/orders/presentation/order/components/action_dialogs.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_item/order_item_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../domain/entities/order.dart';
import 'order_action_buttons.dart';

class NewOrderItemView extends StatelessWidget {
  final Function(Order) seeDetails;
  final VoidCallback onRefresh;
  final Order order;

  const NewOrderItemView(
      {Key? key, required this.order, required this.seeDetails, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            order.status == OrderStatusId.PLACED
                ? Row(
                    children: [
                      AcceptButton(
                        onAccept: () {
                          showOrderActionDialog(
                            id: order.id,
                            status: OrderStatusId.ACCEPTED,
                            context: context,
                            onSuccess: onRefresh,
                            title: 'Accept order #${order.id}',
                            cubit: context.read<OrderActionCubit>(),
                          );
                        },
                      ),
                      SizedBox(width: AppSize.s8.rw),
                      CanceledButton(
                        onCanceled: () {
                          showOrderActionDialog(
                            id: order.id,
                            status: OrderStatusId.CANCELLED,
                            context: context,
                            onSuccess: onRefresh,
                            title: 'Cancel order #${order.id}',
                            cubit: context.read<OrderActionCubit>(),
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      PrintButton(
                        onPrint: () {},
                        padding: AppSize.s16,
                      ),
                      SizedBox(width: AppSize.s8.rw),
                      ReadyButton(
                        onReady: () {
                          showOrderActionDialog(
                            id: order.id,
                            status: OrderStatusId.READY,
                            context: context,
                            onSuccess: onRefresh,
                            title: 'Update order #${order.id}',
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
