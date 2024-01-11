import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/decorated_image_view.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
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
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8),
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
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8),
      ),
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
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8),
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
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8),
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
        ).setVisibilityWithSpace(direction: Axis.horizontal, startSpace: AppSize.s8),
      ),
    ],
  );
}

bool _onlyPrintActionAvailable(Order order) {
  return !(OrderActionButtonManager().canReject(order) || OrderActionButtonManager().canAccept(order) || OrderActionButtonManager().canReady(order) || OrderActionButtonManager().canDelivery(order));
}

Widget getExpandActionButtons({
  required Order order,
  required Function(String, int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
}) {
  bool showPrintOnly = _onlyPrintActionAvailable(order);
  List<Widget> children = [
    if (OrderActionButtonManager().canPrint(order))
      Expanded(
        flex: showPrintOnly ? 1 : 0,
        child: PrintButton(onPrint: onPrint, expanded: showPrintOnly),
      ),
    if (OrderActionButtonManager().canReject(order))
      Expanded(
        child: KTButton(
          controller: KTButtonController(label: AppStrings.reject.tr()),
          prefixWidget: ImageResourceResolver.closeSVG.getImageWidget(width: AppSize.s18.rw, height: AppSize.s18.rh, color: AppColors.errorR300),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.errorR50),
          labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
          splashColor: AppColors.greyBright,
          onTap: () {
            onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
          },
        ),
      ),
    if (OrderActionButtonManager().canAccept(order))
      Expanded(
        child: KTButton(
          controller: KTButtonController(label: AppStrings.accept.tr()),
          prefixWidget: ImageResourceResolver.successSVG.getImageWidget(width: AppSize.s18.rw, height: AppSize.s18.rh, color: AppColors.successG300),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.successG50),
          labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB700),
          splashColor: AppColors.greyBright,
          onTap: () {
            onAction('${AppStrings.accept_order.tr()} #${order.id}', OrderStatus.ACCEPTED);
          },
        ),
      ),
    if (OrderActionButtonManager().canReady(order))
      Expanded(
        child: KTButton(
          controller: KTButtonController(label: AppStrings.ready.tr()),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.successG300),
          labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.white),
          splashColor: AppColors.greyBright,
          verticalContentPadding: 10.rh,
          onTap: () {
            onAction('${AppStrings.ready_order.tr()} #${order.id}', OrderStatus.READY);
          },
        ),
      ),
    if (OrderActionButtonManager().canDelivery(order))
      Expanded(
        child: KTButton(
          controller: KTButtonController(label: AppStrings.deliver.tr()),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
          labelStyle: mediumTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.white),
          splashColor: AppColors.greyBright,
          verticalContentPadding: 10.rh,
          onTap: () {
            onAction('${AppStrings.deliver_order.tr()} #${order.id}', OrderStatus.DELIVERED);
          },
        ),
      ),
  ];

  List<Widget> spacedChildren = [];
  if (children.length > 1) {
    children.forEachIndexed((index, element) {
      spacedChildren.add(element);
      if (index < children.length - 1) {
        spacedChildren.add(AppSize.s8.horizontalSpacer());
      }
    });
  } else {
    spacedChildren = children;
  }

  return Row(
    children: spacedChildren,
  );
}
