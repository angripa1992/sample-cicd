import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/comment_view.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_details_header.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_item_details.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/price_view.dart';
import 'package:klikit/resources/values.dart';

import '../order_item/order_action_buttons.dart';

void _openBottomSheet({
  required BuildContext context,
  required Order order,
  required Widget actionView,
  required GlobalKey<ScaffoldState> key,
  required VoidCallback onCommentActionSuccess,
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
      minChildSize: 0.85,
      maxChildSize: 0.85,
      expand: false,
      builder: (_, controller) => Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        extendBody: false,
        key: key,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            OrderDetailsHeaderView(
              order: order,
              modalKey: key,
              onCommentActionSuccess: onCommentActionSuccess,
            ),
            Padding(
              padding: EdgeInsets.only(top: AppSize.s4.rh),
              child: const Divider(),
            ),
            OrderItemDetails(order: order, controller: controller),
            CommentView(comment: order.orderComment),
            PriceView(order: order),
            actionView,
          ],
        ),
      ),
    ),
  );
}

void showHistoryOrderDetails({
  required BuildContext context,
  required Order order,
  required GlobalKey<ScaffoldState> key,
  required VoidCallback onCommentActionSuccess,
  required VoidCallback onPrint,
}) {
  _openBottomSheet(
    key: key,
    context: context,
    order: order,
    onCommentActionSuccess: onCommentActionSuccess,
    actionView: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s12.rh,
        horizontal: AppSize.s12.rw,
      ),
      child: PrintButton(
        onPrint: onPrint,
      ),
    ),
  );
}

void showOrderDetails({
  required BuildContext context,
  required Order order,
  required Function(String,int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
  required GlobalKey<ScaffoldState> key,
  required VoidCallback onCommentActionSuccess,
}) {
  _openBottomSheet(
    key: key,
    context: context,
    onCommentActionSuccess: onCommentActionSuccess,
    order: order,
    actionView: Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s12.rh,
        horizontal: AppSize.s12.rw,
      ),
      child: getExpandActionButtons(
        order: order,
        onAction: onAction,
        onCancel: onCancel,
        onPrint: onPrint,
      ),
    ),
  );
}
