import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/assets.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class PrintButton extends StatelessWidget {
  final VoidCallback onPrint;
  final double padding;

  const PrintButton(
      {Key? key, required this.onPrint, this.padding = AppSize.s32})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onPrint,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: padding.rw),
          primary: AppColors.purpleBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp), // <-- Radius
          ),
        ),
        child: Text(
          'Print',
          style: getMediumTextStyle(
            color: AppColors.white,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class ReadyButton extends StatelessWidget {
  final VoidCallback onReady;

  const ReadyButton({
    Key? key,
    required this.onReady,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onReady,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            side: BorderSide(color: AppColors.purpleBlue),
          ),
        ),
        child: Text(
          'Ready',
          style: getMediumTextStyle(
            color: AppColors.purpleBlue,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class DeliverButton extends StatelessWidget {
  final VoidCallback onDeliver;

  const DeliverButton({
    Key? key,
    required this.onDeliver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onDeliver,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            side: BorderSide(color: AppColors.purpleBlue),
          ),
        ),
        child: Text(
          'Deliver',
          style: getMediumTextStyle(
            color: AppColors.purpleBlue,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class PickedUpButton extends StatelessWidget {
  final VoidCallback onPickedUp;

  const PickedUpButton({
    Key? key,
    required this.onPickedUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onPickedUp,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            side: BorderSide(color: AppColors.purpleBlue),
          ),
        ),
        child: Text(
          'Picked Up',
          style: getMediumTextStyle(
            color: AppColors.purpleBlue,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ),
    );
  }
}

class AcceptButton extends StatelessWidget {
  final VoidCallback onAccept;

  const AcceptButton({
    Key? key,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onAccept,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.purpleBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
          ),
        ),
        child: const Icon(Icons.check),
      ),
    );
  }
}

class CanceledButton extends StatelessWidget {
  final VoidCallback onCanceled;

  const CanceledButton({
    Key? key,
    required this.onCanceled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s32.rh,
      child: ElevatedButton(
        onPressed: onCanceled,
        style: ElevatedButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          primary: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s24.rSp),
            side: BorderSide(color: AppColors.black),
          ),
        ),
        child: SvgPicture.asset(AppIcons.canceled),
      ),
    );
  }
}

Widget getActionButtons({
  required Order order,
  required Function(String) onAction,
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
          onAccept: () {
            onAction('Accept Order #${order.id}');
          },
        ),
        SizedBox(width: AppSize.s8.rw),
        CanceledButton(
          onCanceled: () {
            onCancel('Cancel Order #${order.id}');
          },
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
        ),
        SizedBox(width: AppSize.s8.rw),
        DeliverButton(
          onDeliver: () {
            onAction('Deliver Order #${order.id}');
          },
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
        ),
        SizedBox(width: AppSize.s8.rw),
        ReadyButton(
          onReady: () {
            onAction('Ready Order #${order.id}');
          },
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
        ),
        SizedBox(width: AppSize.s8.rw),
        PickedUpButton(
          onPickedUp: () {
            onAction('PickUp Order #${order.id}');
          },
        ),
      ],
    );
  }
  return Row(
    children: [
      PrintButton(
        onPrint: onPrint,
        padding: AppSize.s16,
      ),
      SizedBox(width: AppSize.s8.rw),
      DeliverButton(
        onDeliver: () {
          onAction('Deliver Order #${order.id}');
        },
      ),
    ],
  );
}

Widget getExpandActionButtons({
  required Order order,
  required Function(String) onAction,
  required Function(String) onCancel,
  required VoidCallback onPrint,
}) {
  final orderStatus = order.status;
  final provider = order.providerId;
  final orderType = order.type;
  if (orderStatus == OrderStatus.PLACED) {
    return Row(
      children: [
        Expanded(
          child: AcceptButton(
            onAccept: () {
              onAction('Accept Order #${order.id}');
            },
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: CanceledButton(
            onCanceled: () {
              onCancel('Cancel Order #${order.id}');
            },
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
            onPrint: onPrint,
            padding: AppSize.s16,
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: DeliverButton(
            onDeliver: () {
              onAction('Deliver Order #${order.id}');
            },
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
            onPrint: onPrint,
            padding: AppSize.s16,
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: ReadyButton(
            onReady: () {
              onAction('Ready Order #${order.id}');
            },
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
            onPrint: onPrint,
            padding: AppSize.s16,
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: PickedUpButton(
            onPickedUp: () {
              onAction('PickUp Order #${order.id}');
            },
          ),
        ),
      ],
    );
  }
  return Row(
    children: [
      Expanded(
        child: PrintButton(
          onPrint: onPrint,
          padding: AppSize.s16,
        ),
      ),
      SizedBox(width: AppSize.s8.rw),
      Expanded(
        child: DeliverButton(
          onDeliver: () {
            onAction('Deliver Order #${order.id}');
          },
        ),
      ),
    ],
  );
}
