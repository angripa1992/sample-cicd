import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/notification/inapp/notification_counter.dart';
import 'package:klikit/notification/inapp/notification_sound.dart';
import 'package:klikit/notification/notification_data.dart';
import 'package:klikit/notification/notification_handler.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../app/session_manager.dart';
import '../../core/route/routes_generator.dart';
import '../../printer/printer_manager.dart';
import '../../resources/colors.dart';
import '../../resources/values.dart';
import '../notification_data_handler.dart';

class InAppNotificationHandler {
  static bool _isShowing = false;
  static final _instance = InAppNotificationHandler._internal();
  final _notificationSound = NotificationSound();
  final _printingHandler = getIt.get<PrinterManager>();
  late ValueNotifier<NotificationCounter> _counter;
  final _orderBadgeNotifier = ValueNotifier<bool>(false);

  factory InAppNotificationHandler() => _instance;

  InAppNotificationHandler._internal();

  ValueNotifier<bool> orderBadgeNotifier() => _orderBadgeNotifier;

  void handleNotification(NotificationData data) {
    if (!SessionManager().notificationEnable()) {
      _handleDocketPrinting(data);
      return;
    }
    _initCounter();
    _incrementValue(data.type.toInt());
    _playSoundAndShowDialog(data);
    _handleDocketPrinting(data);
  }

  void _initCounter() {
    if (!_isShowing) {
      _counter = ValueNotifier<NotificationCounter>(NotificationCounter(ongoing: 0, cancelled: 0, scheduled: 0));
    }
  }

  void _incrementValue(int type) {
    final isNewOrder = type == NotificationOrderType.NEW;
    final isScheduleOrder = type == NotificationOrderType.SCHEUDLE;
    final counter = _counter.value;

    if (isNewOrder) {
      _counter.value = counter.copyWith(ongoing: counter.ongoing + 1);
    } else if (isScheduleOrder) {
      _counter.value = counter.copyWith(scheduled: counter.scheduled + 1);
    } else {
      _counter.value = counter.copyWith(cancelled: counter.cancelled + 1);
    }
  }

  void _playSoundAndShowDialog(NotificationData data) {
    final isNewOrder = data.type.toInt() == NotificationOrderType.NEW;
    final isScheduleOrder = data.type.toInt() == NotificationOrderType.SCHEUDLE;
    final counter = _counter.value;

    if (_isShowing) {
      if (counter.ongoing > 0 || counter.scheduled > 0 || isNewOrder || isScheduleOrder) {
        _notificationSound.stop();
        _notificationSound.playNewSound();
      }
    } else {
      _showDialog(data);
      if (isNewOrder || isScheduleOrder) {
        _notificationSound.playNewSound();
      } else {
        _notificationSound.playCancelSound();
      }
    }
  }

  void _handleDocketPrinting(NotificationData notificationData) async {
    final isNewOrder = notificationData.type.toInt() == NotificationOrderType.NEW;
    if (!isNewOrder) {
      return;
    }
    Future.delayed(const Duration(seconds: 2), () async {
      final order = await NotificationDataHandler().getOrderById(
        notificationData.orderId.toInt(),
      );
      if (order != null && order.status == OrderStatus.ACCEPTED) {
        await _printingHandler.doAutoDocketPrinting(order: order, isFromBackground: false);
      }
    });
  }

  void _dismissInAppNotification() {
    _notificationSound.stop();
    _isShowing = false;
    _counter.dispose();
  }

  void _notifyOrderBadgeListener() {
    if (_counter.value.ongoing > 0 || _counter.value.scheduled > 0) {
      _orderBadgeNotifier.value = true;
    } else {
      clearOrderBadgeListener();
    }
  }

  void clearOrderBadgeListener() {
    _orderBadgeNotifier.value = false;
  }

  Widget overlapped(NotificationCounter counter) {
    const overlap = 16.0;
    final items = [
      if (counter.ongoing > 0)
        Container(
          padding: EdgeInsets.all(AppSize.s4.rSp),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: AppColors.primaryP50, shape: BoxShape.circle),
          child: ImageResourceResolver.notificationAlertSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.primaryP300),
        ),
      if (counter.scheduled > 0)
        Container(
          padding: EdgeInsets.all(AppSize.s4.rSp),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: AppColors.warningY50, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: ImageResourceResolver.timeSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.warningY300),
        ),
      if (counter.cancelled > 0)
        Container(
          padding: EdgeInsets.all(AppSize.s4.rSp),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: AppColors.errorR50, shape: BoxShape.circle),
          child: ImageResourceResolver.cancelNotificationSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.errorR300),
        ),
    ];

    List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
      return Padding(
        padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
        child: items[index],
      );
    });

    return Stack(children: stackLayers);
  }

  void _showDialog(NotificationData data) {
    _isShowing = true;
    showDialog(
      context: RoutesGenerator.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: _counter,
          builder: (BuildContext context, NotificationCounter counter, Widget? child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
              title: Row(
                children: [
                  overlapped(counter),
                  AppSize.s8.horizontalSpacer(),
                  Text(
                    'New ${counter.totalCount() > 1 ? 'Orders' : 'Order'}!',
                    style: semiBoldTextStyle(
                      color: AppColors.neutralB700,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                  const Spacer(),
                  AppSize.s8.horizontalSpacer(),
                  InkWell(
                    onTap: () {
                      _notifyOrderBadgeListener();
                      Navigator.pop(RoutesGenerator.navigatorKey.currentState!.context);
                    },
                    child: ImageResourceResolver.closeSVG.getImageWidget(width: AppSize.s20.rw, height: AppSize.s20.rh, color: AppColors.neutralB600),
                  )
                ],
              ),
              content: Text(
                "You've got ${counter.totalCount() > 1 ? 'new orders' : 'a new order'} waiting for your approval. Tap to view.",
                style: regularTextStyle(
                  color: AppColors.neutralB200,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              actionsPadding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s24.rh, bottom: AppSize.s16.rh),
              actions: [
                KTButton(
                  controller: KTButtonController(label: AppStrings.view_orders.tr()),
                  backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
                  labelStyle: mediumTextStyle(color: AppColors.white),
                  progressPrimaryColor: AppColors.white,
                  onTap: () {
                    _navigateToOrderScreen(data);
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((value) => _dismissInAppNotification());
  }

  void _navigateToOrderScreen(NotificationData data) {
    Navigator.pop(RoutesGenerator.navigatorKey.currentState!.context);
    NotificationHandler().navigateToOrderScreen(
      data,
      notificationType: NotificationType.IN_APP,
    );
  }
}
