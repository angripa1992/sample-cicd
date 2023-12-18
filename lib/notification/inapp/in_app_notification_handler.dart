import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/notification/inapp/notification_sound.dart';
import 'package:klikit/notification/notification_data.dart';
import 'package:klikit/notification/notification_handler.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../app/session_manager.dart';
import '../../core/route/routes_generator.dart';
import '../../modules/widgets/app_button.dart';
import '../../printer/printing_handler.dart';
import '../../resources/colors.dart';
import '../../resources/values.dart';
import '../notification_data_handler.dart';

class InAppNotificationHandler {
  static bool _isShowing = false;
  static final _instance = InAppNotificationHandler._internal();
  final _notificationSound = NotificationSound();
  final _printingHandler = getIt.get<PrintingHandler>();
  late ValueNotifier<int> _newOrderCounter;
  late ValueNotifier<int> _cancelOrderCounter;
  late ValueNotifier<int> _scheduleCounter;
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
      _newOrderCounter = ValueNotifier<int>(0);
      _cancelOrderCounter = ValueNotifier<int>(0);
      _scheduleCounter = ValueNotifier<int>(0);
    }
  }

  void _incrementValue(int type) {
    final isNewOrder = type == NotificationOrderType.NEW;
    final isScheduleOrder = type == NotificationOrderType.SCHEUDLE;
    if (isNewOrder) {
      _newOrderCounter.value += 1;
    } else if (isScheduleOrder) {
      _scheduleCounter.value += 1;
    } else {
      _cancelOrderCounter.value += 1;
    }
  }

  void _playSoundAndShowDialog(NotificationData data) {
    final isNewOrder = data.type.toInt() == NotificationOrderType.NEW;
    final isScheduleOrder = data.type.toInt() == NotificationOrderType.SCHEUDLE;
    if (_isShowing) {
      if (_newOrderCounter.value > 0 || _scheduleCounter.value > 0 || isNewOrder || isScheduleOrder) {
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
        _printingHandler.printDocket(order: order, isAutoPrint: true);
      }
    });
  }

  void _dismissInAppNotification() {
    _notificationSound.stop();
    _isShowing = false;
    _newOrderCounter.dispose();
    _cancelOrderCounter.dispose();
    _scheduleCounter.dispose();
  }

  void _notifyOrderBadgeListener() {
    if (_newOrderCounter.value > 0 || _scheduleCounter.value > 0) {
      _orderBadgeNotifier.value = true;
    } else {
      clearOrderBadgeListener();
    }
  }

  void clearOrderBadgeListener() {
    _orderBadgeNotifier.value = false;
  }

  void _showDialog(NotificationData data) {
    final textStyle = mediumTextStyle(
      color: AppColors.black,
      fontSize: AppFontSize.s18.rSp,
    );
    _isShowing = true;
    showDialog(
      context: RoutesGenerator.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s8.rSp),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    _notifyOrderBadgeListener();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: AppColors.black),
                ),
              ),
              ValueListenableBuilder<int>(
                valueListenable: _newOrderCounter,
                builder: (_, value, __) {
                  return Visibility(
                    visible: value > 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                      child: Row(
                        children: [
                          Icon(Icons.notifications_on_sharp, color: AppColors.primaryLight),
                          SizedBox(width: AppSize.s16.rw),
                          Expanded(
                            child: Text(
                              '${AppStrings.you_have_received.tr()} $value ${AppStrings.new_orders.tr()} !',
                              style: textStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: _scheduleCounter,
                builder: (_, value, __) {
                  return Visibility(
                    visible: value > 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: AppSize.s16.rh,
                        left: AppSize.s12.rw,
                        right: AppSize.s12.rw,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: AppColors.yellowDark),
                          SizedBox(width: AppSize.s16.rw),
                          Expanded(
                            child: Text(
                              '${AppStrings.you_have_received.tr()} $value scheduled order!',
                              style: textStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: _cancelOrderCounter,
                builder: (_, value, __) {
                  return Visibility(
                    visible: value > 0,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: AppSize.s16.rh,
                        left: AppSize.s12.rw,
                        right: AppSize.s12.rw,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.notification_important_outlined, color: AppColors.red),
                          SizedBox(width: AppSize.s16.rw),
                          Expanded(
                            child: Text(
                              '$value ${AppStrings.orders_has_been_canceled.tr()} !',
                              style: textStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppSize.s16.rh,
                  bottom: AppSize.s8.rh,
                ),
                child: Text(
                  'Tap to view orders',
                  style: regularTextStyle(
                    color: AppColors.greyDarker,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            AppButton(
              onTap: () {
                _navigateToOrderScreen(data);
              },
              text: AppStrings.view_orders.tr(),
            ),
          ],
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
