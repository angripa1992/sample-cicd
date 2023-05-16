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
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onPrint,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          primary: AppColors.purpleBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp), // <-- Radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.print,
              color: AppColors.white,
            ),
            if (expanded)
              Padding(
                padding: EdgeInsets.only(left: AppSize.s8.rw),
                child: Text(
                  'Print',
                  style: getMediumTextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSize.s14.rSp,
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
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: enabled ? onReady : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
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
            fontSize: AppFontSize.s14.rSp,
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
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: enabled ? onDeliver : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
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
            fontSize: AppFontSize.s14.rSp,
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
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: enabled ? onPickedUp : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
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
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: enabled ? onAccept : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.purpleBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check),
            if (expanded)
              Padding(
                padding: EdgeInsets.only(left: AppSize.s8.rw),
                child: Text(
                  'Accept',
                  style: getMediumTextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSize.s14.rSp,
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
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: enabled ? onCanceled : null,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            side: BorderSide(
              color: enabled ? AppColors.black : Colors.transparent,
            ),
          ),
        ),
        child: expanded
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.clear,color: AppColors.darkGrey),
                  if (expanded)
                    Padding(
                      padding: EdgeInsets.only(left: AppSize.s8.rw),
                      child: Text(
                        'Reject',
                        style: getMediumTextStyle(
                          color: AppColors.darkGrey,
                          fontSize: AppFontSize.s14.rSp,
                        ),
                      ),
                    ),
                ],
              )
            : SvgPicture.asset(
                AppIcons.canceled,
                color: enabled ? AppColors.black : AppColors.smokeyGrey,
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
}) {
  final orderStatus = order.status;
  final provider = order.providerId;
  final orderType = order.type;
  if (orderStatus == OrderStatus.PLACED) {
    return Row(
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
        SizedBox(width: AppSize.s8.rw),
        CanceledButton(
          expanded: false,
          onCanceled: () {
            onCancel('${AppStrings.cancel_order.tr()} #${order.id}');
          },
          enabled: !order.isInterceptorOrder,
        ),
      ],
    );
  }
  if (orderStatus == OrderStatus.PICKED_UP &&
      provider == ProviderID.GRAB_FOOD &&
      orderType != OrderType.PICKUP) {
    return Row(
      children: [
        PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
          expanded: false,
        ),
        SizedBox(width: AppSize.s8.rw),
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
  if (orderStatus == OrderStatus.ACCEPTED ||
      (orderStatus == OrderStatus.PICKED_UP &&
          provider != ProviderID.FOOD_PANDA &&
          orderType != OrderType.PICKUP)) {
    return Row(
      children: [
        PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
          expanded: false,
        ),
        SizedBox(width: AppSize.s8.rw),
        ReadyButton(
          expanded: false,
          onReady: () {
            onAction('${AppStrings.ready_order.tr()} #${order.id}',
                OrderStatus.READY);
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
      children: [
        PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
          expanded: false,
        ),
        SizedBox(width: AppSize.s8.rw),
        PickedUpButton(
          expanded: false,
          onPickedUp: () {
            onAction('${AppStrings.pickup_order.tr()} #${order.id}',
                OrderStatus.PICKED_UP);
          },
          enabled: !order.isInterceptorOrder,
        ),
      ],
    );
  }
  return Row(
    children: [
      PrintButton(
        onPrint: onPrint,
        padding: AppSize.s16,
        expanded: false,
      ),
      SizedBox(width: AppSize.s8.rw),
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
  if (orderStatus == OrderStatus.READY &&
      (provider == ProviderID.FOOD_PANDA || provider == ProviderID.GRAB_FOOD) &&
      orderType == OrderType.PICKUP) {
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
