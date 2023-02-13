import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/comment_view.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_details_header.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/order_item_details.dart';
import 'package:klikit/modules/orders/presentation/order/components/details/price_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
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
      initialChildSize: 0.90,
      maxChildSize: 0.90,
      minChildSize: 0.90,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
                  child: Text(
                    AppStrings.order_details.tr(),
                    style: getRegularTextStyle(
                      color: AppColors.blackCow,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_rounded,
                    size: AppSize.s18.rSp,
                    color: AppColors.blackCow,
                  ),
                )
              ],
            ),
            OrderDetailsHeaderView(
              order: order,
              modalKey: key,
              onCommentActionSuccess: onCommentActionSuccess,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: AppSize.s8.rh,
                left: AppSize.s16.rw,
                right: AppSize.s16.rw,
              ),
              child: Divider(color: AppColors.lightViolet),
            ),
            OrderItemDetails(order: order),
            CommentView(comment: order.orderComment),
            PriceView(order: order),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s8.rh,
                horizontal: AppSize.s16.rw,
              ),
              child: actionView,
            ),
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
    actionView: PrintButton(
      onPrint: onPrint,
    ),
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
}) {
  _openBottomSheet(
    key: key,
    context: context,
    onCommentActionSuccess: onCommentActionSuccess,
    order: order,
    actionView: getExpandActionButtons(
      order: order,
      onAction: onAction,
      onCancel: onCancel,
      onPrint: onPrint,
    ),
  );
}
