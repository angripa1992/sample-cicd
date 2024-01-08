import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
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
  return Wrap(
    alignment: WrapAlignment.end,
    runSpacing: AppSize.s8.rh,
    children: [
      Visibility(
        visible: OrderActionButtonManager().canAccept(order),
        child: DecoratedImageView(
          iconWidget: ImageResourceResolver.successSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.successG300),
          padding: EdgeInsets.all(AppSize.s10.rSp),
          decoration: BoxDecoration(
            color: AppColors.neutralB20,
            borderRadius: BorderRadius.all(
              Radius.circular(200.rSp),
            ),
          ),
          onTap: () {
            onAction('${AppStrings.accept_order.tr()} #${order.id}', OrderStatus.ACCEPTED);
          },
        ),
      ),
      Visibility(
        visible: OrderActionButtonManager().canReject(order),
        child: DecoratedImageView(
          iconWidget: ImageResourceResolver.cancelSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.errorR300),
          padding: EdgeInsets.all(AppSize.s10.rSp),
          decoration: BoxDecoration(
            color: AppColors.neutralB20,
            borderRadius: BorderRadius.all(
              Radius.circular(200.rSp),
            ),
          ),
          onTap: () {
            onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
          },
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8.rw),
      ),
      Visibility(
        visible: OrderActionButtonManager().canPrint(order),
        child: DecoratedImageView(
          iconWidget: ImageResourceResolver.printerSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.neutralB600),
          padding: EdgeInsets.all(AppSize.s10.rSp),
          decoration: BoxDecoration(
            color: AppColors.neutralB20,
            borderRadius: BorderRadius.all(
              Radius.circular(200.rSp),
            ),
          ),
          onTap: onPrint,
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8.rw),
      ),
      Visibility(
        visible: OrderActionButtonManager().canReady(order),
        child: DecoratedImageView(
          iconWidget: ImageResourceResolver.readyFoodSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.successG300),
          padding: EdgeInsets.all(AppSize.s10.rSp),
          decoration: BoxDecoration(
            color: AppColors.successG50,
            borderRadius: BorderRadius.all(
              Radius.circular(200.rSp),
            ),
          ),
          onTap: () {
            onAction('${AppStrings.ready_order.tr()} #${order.id}', OrderStatus.READY);
          },
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8.rw),
      ),
      Visibility(
        visible: OrderActionButtonManager().canUpdateOrder(order),
        child: DecoratedImageView(
          iconWidget: ImageResourceResolver.editSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.neutralB600),
          padding: EdgeInsets.all(AppSize.s10.rSp),
          decoration: BoxDecoration(
            color: AppColors.neutralB20,
            borderRadius: BorderRadius.all(
              Radius.circular(200.rSp),
            ),
          ),
          onTap: () {
            onEditManualOrder();
          },
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8.rw),
      ),
      Visibility(
        visible: OrderActionButtonManager().canDelivery(order),
        child: DecoratedImageView(
          iconWidget: ImageResourceResolver.deliveryCardSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.primaryP300),
          padding: EdgeInsets.all(AppSize.s10.rSp),
          decoration: BoxDecoration(
            color: AppColors.primaryP50,
            borderRadius: BorderRadius.all(
              Radius.circular(200.rSp),
            ),
          ),
          onTap: () {
            onAction('${AppStrings.deliver_order.tr()} #${order.id}', OrderStatus.DELIVERED);
          },
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8.rw),
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
