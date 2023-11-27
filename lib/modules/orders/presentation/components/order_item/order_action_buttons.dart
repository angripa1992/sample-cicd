import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import 'order_action_button_components.dart';
import 'order_action_button_manager.dart';

Widget getActionButtons({
  required Order order,
  required Function(String, int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
  required VoidCallback onEditGrabOrder,
  required VoidCallback onEditManualOrder,
  required VoidCallback onRiderFind,
}) {
  final gapBetweenButtons = ScreenSizes.isTablet ? EdgeInsets.symmetric(horizontal: AppSize.s2.rw) : EdgeInsets.zero;
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Visibility(
        visible: OrderActionButtonManager().canAccept(order),
        child: Padding(
          padding: gapBetweenButtons,
          child: AcceptButton(
            expanded: false,
            enabled: true,
            onAccept: () {
              onAction('${AppStrings.accept_order.tr()} #${order.id}', OrderStatus.ACCEPTED);
            },
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canReject(order),
        child: Padding(
          padding: gapBetweenButtons,
          child: CanceledButton(
            expanded: false,
            enabled: true,
            onCanceled: () {
              onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
            },
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canReady(order),
        child: Padding(
          padding: gapBetweenButtons,
          child: ReadyButton(
            expanded: false,
            enabled: true,
            onReady: () {
              onAction('${AppStrings.ready_order.tr()} #${order.id}', OrderStatus.READY);
            },
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canDelivery(order),
        child: Padding(
          padding: gapBetweenButtons,
          child: DeliverButton(
            expanded: false,
            enabled: true,
            onDeliver: () {
              onAction('${AppStrings.deliver_order.tr()} #${order.id}', OrderStatus.DELIVERED);
            },
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canUpdateOrder(order),
        child: Padding(
          padding: gapBetweenButtons,
          child: EditButton(
            onEdit: () {
              onEditManualOrder();
            },
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canPrint(order),
        child: Padding(
          padding: gapBetweenButtons,
          child: PrintButton(
            onPrint: onPrint,
            padding: AppSize.s16,
            expanded: false,
          ),
        ),
      ),
    ],
  );
}

Widget getExpandActionButtons({
  required Order order,
  required Function(String, int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Visibility(
        visible: OrderActionButtonManager().canAccept(order),
        child: Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s2.rw),
            child: AcceptButton(
              expanded: true,
              enabled: true,
              onAccept: () {
                onAction('${AppStrings.accept_order.tr()} #${order.id}', OrderStatus.ACCEPTED);
              },
            ),
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canReject(order),
        child: Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s2.rw),
            child: CanceledButton(
              expanded: true,
              enabled: true,
              onCanceled: () {
                onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
              },
            ),
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canReady(order),
        child: Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s2.rw),
            child: ReadyButton(
              expanded: true,
              enabled: true,
              onReady: () {
                onAction('${AppStrings.ready_order.tr()} #${order.id}', OrderStatus.READY);
              },
            ),
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canDelivery(order),
        child: Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s2.rw),
            child: DeliverButton(
              expanded: true,
              enabled: true,
              onDeliver: () {
                onAction('${AppStrings.deliver_order.tr()} #${order.id}', OrderStatus.DELIVERED);
              },
            ),
          ),
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canPrint(order),
        child: Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s2.rw),
            child: PrintButton(
              onPrint: onPrint,
              padding: AppSize.s16,
              expanded: true,
            ),
          ),
        ),
      ),
    ],
  );
}
