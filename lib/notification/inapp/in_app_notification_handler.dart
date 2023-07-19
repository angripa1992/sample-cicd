import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/notification/inapp/notification_sound.dart';
import 'package:klikit/notification/notification_data.dart';
import 'package:klikit/notification/notification_handler.dart';
import 'package:klikit/resources/strings.dart';

import '../../core/route/routes_generator.dart';
import '../../modules/widgets/app_button.dart';
import '../../modules/widgets/loading_button.dart';
import '../../printer/printing_handler.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import '../notification_data_handler.dart';

class InAppNotificationHandler {
  static bool _isShowing = false;
  static final _instance = InAppNotificationHandler._internal();
  final _notificationSound = NotificationSound();
  final _printingHandler = getIt.get<PrintingHandler>();
  late ValueNotifier<int> _newOrderCounter;
  late ValueNotifier<int> _cancelOrderCounter;

  factory InAppNotificationHandler() => _instance;

  InAppNotificationHandler._internal();

  void handleNotification(NotificationData data) {
    final isNewOrder = data.type.toInt() == NotificationOrderType.NEW;
    if (!_isShowing) {
      _newOrderCounter = ValueNotifier<int>(0);
      _cancelOrderCounter = ValueNotifier<int>(0);
    }
    if (isNewOrder) {
      _newOrderCounter.value += 1;
    } else {
      _cancelOrderCounter.value += 1;
    }
    if (_isShowing) {
      if (_newOrderCounter.value > 0 || isNewOrder) {
        _notificationSound.stop();
        _notificationSound.playNewSound();
      }
    } else {
      _showDialog(data);
      if (isNewOrder) {
        _notificationSound.playNewSound();
      } else {
        _notificationSound.playCancelSound();
      }
    }
    _handleDocketPrinting(data);
  }

  void _navigateToOrderScreen(NotificationData data) {
    Navigator.pop(RoutesGenerator.navigatorKey.currentState!.context);
    NotificationHandler().navigateToOrderScreen(
      data,
      notificationType: NotificationType.IN_APP,
    );
  }

  void _handleDocketPrinting(NotificationData notificationData) async {
    final order = await NotificationDataHandler().getOrderById(
      notificationData.orderId.toInt(),
    );
    if (order != null && order.status == OrderStatus.ACCEPTED) {
      _printingHandler.printDocket(order: order, isAutoPrint: true);
    }
  }

  void _dismissInAppNotification() {
    _notificationSound.stop();
    _isShowing = false;
    _newOrderCounter.dispose();
    _cancelOrderCounter.dispose();
  }

  void _showDialog(NotificationData data) {
    _isShowing = true;
    showDialog(
      context: RoutesGenerator.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<int>(
                valueListenable: _cancelOrderCounter,
                builder: (_, value, __) {
                  return Visibility(
                    visible: value > 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSize.s24),
                      child: Text(
                        '$value ${AppStrings.orders_has_been_canceled.tr()}',
                        style: regularTextStyle(
                          color: AppColors.warmRed,
                          fontSize: AppFontSize.s18.rSp,
                        ),
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: _newOrderCounter,
                builder: (_, value, __) {
                  return Visibility(
                    visible: value > 0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSize.s24),
                      child: Text(
                        '${AppStrings.you_have_received.tr()} $value ${AppStrings.new_orders.tr()}',
                        style: regularTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s18.rSp,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.s32,
                  vertical: AppSize.s8,
                ),
                child: AppButton(
                  onTap: () {
                    _navigateToOrderScreen(data);
                  },
                  text: AppStrings.view_orders.tr(),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) => _dismissInAppNotification());
  }
}
