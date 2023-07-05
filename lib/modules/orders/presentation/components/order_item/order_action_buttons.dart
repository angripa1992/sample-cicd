import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class PrintButton extends StatelessWidget {
  final VoidCallback onPrint;
  final double padding;
  final bool expanded;

  const PrintButton({
    Key? key,
    required this.onPrint,
    this.padding = AppSize.s32,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: onPrint,
        style: ElevatedButton.styleFrom(
            minimumSize: Size.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            ),
            side: BorderSide(color: AppColors.purpleBlue)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.print,
              size: AppSize.s16.rSp,
              color: AppColors.purpleBlue,
            ),
            if (expanded)
              Padding(
                padding: EdgeInsets.only(left: AppSize.s8.rw),
                child: Text(
                  AppStrings.print.tr(),
                  style: getMediumTextStyle(
                    color: AppColors.purpleBlue,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ReadyButton extends StatelessWidget {
  final VoidCallback onReady;
  final bool enabled;
  final bool expanded;

  const ReadyButton({
    Key? key,
    required this.onReady,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onReady : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(
              color: enabled ? AppColors.purpleBlue : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          AppStrings.ready.tr(),
          style: getMediumTextStyle(
            color: enabled ? AppColors.purpleBlue : AppColors.smokeyGrey,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
      ),
    );
  }
}

class DeliverButton extends StatelessWidget {
  final VoidCallback onDeliver;
  final bool enabled;
  final bool expanded;

  const DeliverButton({
    Key? key,
    required this.onDeliver,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onDeliver : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(
              color: enabled ? AppColors.purpleBlue : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          AppStrings.deliver.tr(),
          style: getMediumTextStyle(
            color: enabled ? AppColors.purpleBlue : AppColors.smokeyGrey,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
      ),
    );
  }
}

class PickedUpButton extends StatelessWidget {
  final VoidCallback onPickedUp;
  final bool enabled;
  final bool expanded;

  const PickedUpButton({
    Key? key,
    required this.onPickedUp,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onPickedUp : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(
              color: enabled ? AppColors.purpleBlue : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          AppStrings.picked_up.tr(),
          style: getMediumTextStyle(
            color: enabled ? AppColors.purpleBlue : AppColors.smokeyGrey,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class AcceptButton extends StatelessWidget {
  final VoidCallback onAccept;
  final bool enabled;
  final bool expanded;

  const AcceptButton({
    Key? key,
    required this.onAccept,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onAccept : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(
              color: AppColors.green,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check,
              size: AppSize.s16.rSp,
              color: AppColors.green,
            ),
            if (expanded)
              Padding(
                padding: EdgeInsets.only(left: AppSize.s8.rw),
                child: Text(
                  AppStrings.accept.tr(),
                  style: getMediumTextStyle(
                    color: AppColors.green,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CanceledButton extends StatelessWidget {
  final VoidCallback onCanceled;
  final bool enabled;
  final bool expanded;

  const CanceledButton({
    Key? key,
    required this.onCanceled,
    required this.enabled,
    required this.expanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: enabled ? onCanceled : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              side: BorderSide(color: AppColors.red)),
        ),
        child: expanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.clear, color: AppColors.red),
                  if (expanded)
                    Padding(
                      padding: EdgeInsets.only(left: AppSize.s8.rw),
                      child: Text(
                        AppStrings.reject.tr(),
                        style: getMediumTextStyle(
                          color: AppColors.red,
                          fontSize: AppFontSize.s12.rSp,
                        ),
                      ),
                    ),
                ],
              )
            : Icon(
                Icons.clear,
                size: AppSize.s16.rSp,
                color: AppColors.red,
              ),
      ),
    );
  }
}

class EditButton extends StatelessWidget {
  final VoidCallback onEdit;

  const EditButton({
    Key? key,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: onEdit,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              side: BorderSide(color: AppColors.purpleBlue)),
        ),
        child: SvgPicture.asset(
          AppIcons.tablerEdit,
          color: AppColors.purpleBlue,
          height: AppSize.s16.rh,
          width: AppSize.s16.rw,
        ),
      ),
    );
  }
}

class FindRiderButton extends StatelessWidget {
  final VoidCallback onFound;

  const FindRiderButton({
    Key? key,
    required this.onFound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s28.rh,
      child: ElevatedButton(
        onPressed: onFound,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              side: BorderSide(color: AppColors.purpleBlue)),
        ),
        child: Icon(
          Icons.delivery_dining_rounded,
          size: AppSize.s16.rSp,
          color: AppColors.purpleBlue,
        ),
      ),
    );
  }
}

Widget getActionButtons({
  required Order order,
  required Function(String, int) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
  required VoidCallback onEditGrabOrder,
  required VoidCallback onEditManualOrder,
  required VoidCallback onRiderFind,
}) {
  final orderStatus = order.status;
  final provider = order.providerId;
  final orderType = order.type;
  final canUpdateGrabOrder = (provider == ProviderID.GRAB_FOOD) &&
      order.externalId.isNotEmpty &&
      order.canUpdate;
  final canUpdateManualOrder = (provider == ProviderID.KLIKIT) &&
      order.isManualOrder &&
      (orderStatus == OrderStatus.ACCEPTED ||
          orderStatus == OrderStatus.PLACED);
  if (orderStatus == OrderStatus.PLACED) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AcceptButton(
          expanded: false,
          onAccept: () {
            onAction(
              '${AppStrings.accept_order.tr()} #${order.id}',
              OrderStatus.ACCEPTED,
            );
          },
          enabled: !order.isInterceptorOrder,
        ),
        if(ScreenSizes.isTablet) SizedBox(width: AppSize.s8.rw),
        CanceledButton(
          expanded: false,
          onCanceled: () {
            onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
          },
          enabled: !order.isInterceptorOrder,
        ),
        if (canUpdateGrabOrder || canUpdateManualOrder)
          EditButton(
            onEdit: () {
              if (canUpdateManualOrder) {
                onEditManualOrder();
              } else {
                onEditGrabOrder();
              }
            },
          ),
      ],
    );
  }
  if (orderStatus == OrderStatus.PICKED_UP && provider == ProviderID.GRAB_FOOD && orderType != OrderType.PICKUP) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
          expanded: false,
        ),
        if(ScreenSizes.isTablet) SizedBox(width: AppSize.s8.rw),
        DeliverButton(
          expanded: false,
          onDeliver: () {
            onAction('${AppStrings.deliver_order.tr()} #${order.id}',
                OrderStatus.DELIVERED);
          },
          enabled: !order.isInterceptorOrder,
        ),
      ],
    );
  }
  if (orderStatus == OrderStatus.ACCEPTED || (orderStatus == OrderStatus.PICKED_UP && provider != ProviderID.FOOD_PANDA && orderType != OrderType.PICKUP)) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
          expanded: false,
        ),
        if (order.isThreePlOrder && order.canFindFulfillmentRider)
          FindRiderButton(
            onFound: onRiderFind,
          ),
        if (canUpdateGrabOrder || canUpdateManualOrder)
          EditButton(
            onEdit: () {
              if (canUpdateManualOrder) {
                onEditManualOrder();
              } else {
                onEditGrabOrder();
              }
            },
          ),
        if(ScreenSizes.isTablet) SizedBox(width: AppSize.s8.rw),
        ReadyButton(
          expanded: false,
          onReady: () {
            onAction('${AppStrings.ready_order.tr()} #${order.id}', OrderStatus.READY);
          },
          enabled: !order.isInterceptorOrder,
        ),
      ],
    );
  }
  if (orderStatus == OrderStatus.READY &&
      (provider == ProviderID.FOOD_PANDA || provider == ProviderID.GRAB_FOOD) &&
      orderType == OrderType.PICKUP) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
          expanded: false,
        ),
        if(ScreenSizes.isTablet)  SizedBox(width: AppSize.s8.rw),
        PickedUpButton(
          expanded: false,
          onPickedUp: () {
            onAction('${AppStrings.pickup_order.tr()} #${order.id}',
                OrderStatus.PICKED_UP);
          },
          enabled: !order.isInterceptorOrder,
        ),
        if (canUpdateGrabOrder) EditButton(onEdit: onEditGrabOrder),
      ],
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      PrintButton(
        onPrint: onPrint,
        padding: AppSize.s16,
        expanded: false,
      ),
      if(ScreenSizes.isTablet) SizedBox(width: AppSize.s8.rw),
      if (order.isThreePlOrder && order.canFindFulfillmentRider)
        FindRiderButton(
          onFound: onRiderFind,
        ),
      if (order.isThreePlOrder && order.canMarkCancel)
        CanceledButton(
          onCanceled: () {
            onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
          },
          enabled: true,
          expanded: false,
        ),
      if (!order.isThreePlOrder)
        DeliverButton(
          expanded: false,
          onDeliver: () {
            onAction('${AppStrings.deliver_order.tr()} #${order.id}',
                OrderStatus.DELIVERED);
          },
          enabled: !order.isInterceptorOrder,
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
  final orderStatus = order.status;
  final provider = order.providerId;
  final orderType = order.type;
  if (orderStatus == OrderStatus.SCHEDULED) {
    return PrintButton(
      expanded: true,
      onPrint: onPrint,
      padding: AppSize.s16,
    );
  }
  if (orderStatus == OrderStatus.PLACED) {
    return Row(
      children: [
        Expanded(
          child: AcceptButton(
            expanded: true,
            onAccept: () {
              onAction(
                '${AppStrings.accept_order.tr()} #${order.id}',
                OrderStatus.ACCEPTED,
              );
            },
            enabled: !order.isInterceptorOrder,
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: CanceledButton(
            expanded: true,
            onCanceled: () {
              onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
            },
            enabled: !order.isInterceptorOrder,
          ),
        ),
      ],
    );
  }
  if (orderStatus == OrderStatus.PICKED_UP &&
      provider == ProviderID.GRAB_FOOD &&
      orderType != OrderType.PICKUP) {
    return Row(
      children: [
        Expanded(
          child: PrintButton(
            expanded: true,
            onPrint: onPrint,
            padding: AppSize.s16,
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: DeliverButton(
            expanded: true,
            onDeliver: () {
              onAction(
                '${AppStrings.deliver_order.tr()} #${order.id}',
                OrderStatus.DELIVERED,
              );
            },
            enabled: !order.isInterceptorOrder,
          ),
        ),
      ],
    );
  }
  if (orderStatus == OrderStatus.ACCEPTED ||
      (orderStatus == OrderStatus.PICKED_UP &&
          provider != ProviderID.FOOD_PANDA &&
          orderType != OrderType.PICKUP)) {
    return Row(
      children: [
        Expanded(
          child: PrintButton(
            expanded: true,
            onPrint: onPrint,
            padding: AppSize.s16,
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: ReadyButton(
            expanded: true,
            onReady: () {
              onAction(
                '${AppStrings.ready_order.tr()} #${order.id}',
                OrderStatus.READY,
              );
            },
            enabled: !order.isInterceptorOrder,
          ),
        ),
      ],
    );
  }
  if (orderStatus == OrderStatus.READY && (provider == ProviderID.FOOD_PANDA || provider == ProviderID.GRAB_FOOD) && orderType == OrderType.PICKUP) {
    return Row(
      children: [
        Expanded(
          child: PrintButton(
            expanded: true,
            onPrint: onPrint,
            padding: AppSize.s16,
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: PickedUpButton(
            expanded: true,
            onPickedUp: () {
              onAction(
                '${AppStrings.pickup_order.tr()} #${order.id}',
                OrderStatus.PICKED_UP,
              );
            },
            enabled: !order.isInterceptorOrder,
          ),
        ),
      ],
    );
  }
  return Row(
    children: [
      Expanded(
        child: PrintButton(
          expanded: true,
          onPrint: onPrint,
          padding: AppSize.s16,
        ),
      ),
      SizedBox(width: AppSize.s8.rw),
      if (order.isThreePlOrder && order.canMarkCancel)
        Expanded(
          child: CanceledButton(
            onCanceled: () {
              onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
            },
            enabled: true,
            expanded: false,
          ),
        ),
      if (!order.isThreePlOrder)
        Expanded(
          child: DeliverButton(
            expanded: true,
            onDeliver: () {
              onAction(
                '${AppStrings.deliver_order.tr()} #${order.id}',
                OrderStatus.DELIVERED,
              );
            },
            enabled: !order.isInterceptorOrder,
          ),
        ),
    ],
  );
}
