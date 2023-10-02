import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/order.dart';
import 'order_action_button_components.dart';

Widget getWoltOrderActionButtons({
  required Order order,
  required Function(String, int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
}) {
  final autoAccept = order.autoAccept;
  final status = order.status;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      PrintButton(
        onPrint: onPrint,
        padding: AppSize.s16,
        expanded: false,
      ),
      Visibility(
        visible: status == OrderStatus.PLACED,
        child: AcceptButton(
          expanded: false,
          onAccept: () {
            onAction(
              '${AppStrings.accept_order.tr()} #${order.id}',
              OrderStatus.ACCEPTED,
            );
          },
          enabled: !autoAccept,
        ),
      ),
      Visibility(
        visible: status == OrderStatus.PLACED || status == OrderStatus.ACCEPTED || status == OrderStatus.READY,
        child: CanceledButton(
          onCanceled: () {
            onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
          },
          enabled: !autoAccept && status == OrderStatus.PLACED,
          expanded: false,
        ),
      ),
      Visibility(
        visible: status == OrderStatus.ACCEPTED,
        child: ReadyButton(
          expanded: false,
          onReady: () {
            onAction('${AppStrings.ready_order.tr()} #${order.id}', OrderStatus.READY);
          },
          enabled: true,
        ),
      ),
      Visibility(
        visible: status == OrderStatus.READY,
        child: DeliverButton(
          expanded: false,
          onDeliver: () {
            onAction('${AppStrings.deliver_order.tr()} #${order.id}', OrderStatus.DELIVERED);
          },
          enabled: order.type == OrderType.PICKUP,
        ),
      ),
    ],
  );
}

Widget getExpandedWoltOrderActionButtons({
  required Order order,
  required Function(String, int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
}) {
  final autoAccept = order.autoAccept;
  final status = order.status;
  return Row(
    children: [
      Expanded(
        child: PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
          expanded: true,
        ),
      ),
      SizedBox(width: AppSize.s8.rw),
      Visibility(
        visible: status == OrderStatus.PLACED,
        child: Expanded(
          child: AcceptButton(
            expanded: true,
            onAccept: () {
              onAction(
                '${AppStrings.accept_order.tr()} #${order.id}',
                OrderStatus.ACCEPTED,
              );
            },
            enabled: !autoAccept,
          ),
        ),
      ),
      SizedBox(width: AppSize.s8.rw),
      Visibility(
        visible: status == OrderStatus.PLACED || status == OrderStatus.ACCEPTED || status == OrderStatus.READY,
        child: Expanded(
          child: CanceledButton(
            onCanceled: () {
              onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
            },
            enabled: !autoAccept && status == OrderStatus.PLACED,
            expanded: true,
          ),
        ),
      ),
      SizedBox(width: AppSize.s8.rw),
      Visibility(
        visible: status == OrderStatus.ACCEPTED,
        child: Expanded(
          child: ReadyButton(
            expanded: true,
            onReady: () {
              onAction('${AppStrings.ready_order.tr()} #${order.id}', OrderStatus.READY);
            },
            enabled: true,
          ),
        ),
      ),
      SizedBox(width: AppSize.s8.rw),
      Visibility(
        visible: status == OrderStatus.READY,
        child: Expanded(
          child: DeliverButton(
            expanded: true,
            onDeliver: () {
              onAction('${AppStrings.deliver_order.tr()} #${order.id}', OrderStatus.DELIVERED);
            },
            enabled: order.type == OrderType.PICKUP,
          ),
        ),
      ),
    ],
  );
}
