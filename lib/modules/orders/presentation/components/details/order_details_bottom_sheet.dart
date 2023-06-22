import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../../resources/colors.dart';
import '../order_item/order_action_buttons.dart';
import 'order_details_screen.dart';

void _openBottomSheet({
  required BuildContext context,
  required Order order,
  required Widget actionView,
  required GlobalKey<ScaffoldState> key,
  required VoidCallback onCommentActionSuccess,
  required VoidCallback onGrabEditSuccess,
  required VoidCallback onEditManualOrder,
  required VoidCallback onRiderFind,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      extendBody: false,
      key: key,
      body: Container(
        margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
        color: AppColors.pearl,
        child: OrderDetailsScreen(
          order: order,
          onCommentActionSuccess: onCommentActionSuccess,
          onGrabEditSuccess: onGrabEditSuccess,
          actionView: actionView,
          onEditManualOrder: onEditManualOrder,
          onRiderFind: onRiderFind,
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
  required VoidCallback onGrabEditSuccess,
  required VoidCallback onEditManualOrder,
  required VoidCallback onRiderFind,
}) {
  _openBottomSheet(
    key: key,
    context: context,
    order: order,
    onCommentActionSuccess: onCommentActionSuccess,
    onGrabEditSuccess: onGrabEditSuccess,
    actionView: PrintButton(
      onPrint: onPrint,
      expanded: true,
    ),
    onEditManualOrder: onEditManualOrder,
    onRiderFind: onRiderFind,
  );
}

void showOrderDetails({
  required BuildContext context,
  required Order order,
  required Function(String, int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
  required GlobalKey<ScaffoldState> key,
  required VoidCallback onCommentActionSuccess,
  required VoidCallback onGrabEditSuccess,
  required VoidCallback onEditManualOrder,
  required VoidCallback onRiderFind,
}) {
  _openBottomSheet(
    key: key,
    context: context,
    onCommentActionSuccess: onCommentActionSuccess,
    onGrabEditSuccess: onGrabEditSuccess,
    order: order,
    actionView: getExpandActionButtons(
      order: order,
      onAction: onAction,
      onCancel: onCancel,
      onPrint: onPrint,
    ),
    onEditManualOrder: onEditManualOrder,
    onRiderFind: onRiderFind,
  );
}
