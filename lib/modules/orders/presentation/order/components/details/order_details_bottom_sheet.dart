import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/comment_view.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_details_header.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_item_details.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/price_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../domain/entities/order_status.dart';
import '../order_item/order_action_buttons.dart';

void _openBottomSheet({
  required BuildContext context,
  required Order order,
  required Widget actionView,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OrderDetailsHeaderView(order: order),
          OrderItemDetails(order: order, controller: controller),
          CommentView(comment: order.klikitComment),
          PriceView(order: order),
          actionView,
        ],
      ),
    ),
  );
}

void showHistoryOrderDetails(BuildContext context, Order order) {
  _openBottomSheet(
    context: context,
    order: order,
    actionView: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s12.rh,
        horizontal: AppSize.s12.rw,
      ),
      child: PrintButton(
        onPrint: () {},
      ),
    ),
  );
}

void showNewOrderDetails(BuildContext context, Order order) {
  _openBottomSheet(
    context: context,
    order: order,
    actionView: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s12.rh,
        horizontal: AppSize.s12.rw,
      ),
      child: order.status == OrderStatusId.PLACED
          ? Row(
              children: [
                Expanded(
                  child: AcceptButton(
                    onAccept: () {},
                  ),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: CanceledButton(
                    onCanceled: () {},
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: PrintButton(
                    onPrint: () {},
                    padding: AppSize.s16,
                  ),
                ),
                SizedBox(width: AppSize.s8.rw),
                Expanded(
                  child: ReadyButton(
                    onReady: () {},
                  ),
                ),
              ],
            ),
    ),
  );
}
