import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/notification/inapp/notification_sound.dart';
import 'package:klikit/notification/notification_data.dart';
import 'package:klikit/notification/notification_handler.dart';

import '../../core/route/routes_generator.dart';
import '../../modules/widgets/loading_button.dart';
import '../../printer/printing_handler.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import '../notification_data_handler.dart';
import 'notification_count_cubit.dart';

class InAppNotificationHandler {
  static bool _isShowing = false;
  static final _instance = InAppNotificationHandler._internal();
  final _notificationSound = NotificationSound();
  final _printingHandler = getIt.get<PrintingHandler>();
  final _appPreferences = getIt.get<AppPreferences>();
  BuildContext? _currentContext;

  factory InAppNotificationHandler() => _instance;

  InAppNotificationHandler._internal();

  void handleNotification(NotificationData data) {
    if(!_appPreferences.isLoggedIn()){
      return;
    }
    if (_isShowing) {
      final currentNotificationCountData =
          _currentContext?.read<NotificationCountCubit>().state;
      late NotificationCountData notificationCountData;
      if (data.type.toInt() == NotificationOrderType.NEW) {
        notificationCountData = NotificationCountData(
          numOfNewOrders: currentNotificationCountData!.numOfNewOrders + 1,
          numOfCancelOrders: currentNotificationCountData.numOfCancelOrders,
        );
      } else {
        notificationCountData = NotificationCountData(
          numOfNewOrders: currentNotificationCountData!.numOfNewOrders,
          numOfCancelOrders: currentNotificationCountData.numOfCancelOrders + 1,
        );
      }
      if (currentNotificationCountData.numOfNewOrders > 0 ||
          data.type.toInt() == NotificationOrderType.NEW) {
        _stopSound();
        _playNewSound();
      }
      _currentContext
          ?.read<NotificationCountCubit>()
          .update(notificationCountData);
    } else {
      late NotificationCountData notificationCountData;
      if (data.type.toInt() == NotificationOrderType.NEW) {
        notificationCountData =
            NotificationCountData(numOfNewOrders: 1, numOfCancelOrders: 0);
        _playNewSound();
      } else {
        notificationCountData =
            NotificationCountData(numOfNewOrders: 0, numOfCancelOrders: 1);
        _playCancelSound();
      }
      final cubit = NotificationCountCubit(notificationCountData);
      _showDialog(data, cubit);
      _isShowing = true;
    }
    _handleDocketPrinting(data);
  }

  void _handleDocketPrinting(NotificationData notificationData) async{
    final order = await NotificationDataHandler().getOrderById(notificationData.orderId.toInt());
    if(order != null && order.status == OrderStatus.ACCEPTED){
      _printingHandler.verifyConnection(order: order);
    }
  }

  void _playNewSound() {
    _notificationSound.playNewSound();
  }

  void _playCancelSound() {
    _notificationSound.playCancelSound();
  }

  void _stopSound() {
    _notificationSound.stop();
  }

  void dismissInAppNotification() {
    if (_currentContext != null && _isShowing) {
      Navigator.pop(_currentContext!);
    }
    _stopSound();
    _isShowing = false;
  }

  bool currentlyShowingAnyNotification() => _isShowing;

  void _navigateToOrderScreen(NotificationData data) {
    dismissInAppNotification();
    NotificationHandler().navigateToOrderScreen(data,notificationType: NotificationType.IN_APP);
  }

  void _showDialog(NotificationData data, NotificationCountCubit cubit) {
    showDialog(
      context: RoutesGenerator.navigatorKey.currentState!.context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider(
          create: (_) => cubit,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppSize.s16.rSp),
              ),
            ),
            content: BlocBuilder<NotificationCountCubit, NotificationCountData>(
              builder: (context, state) {
                _currentContext = context;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: state.numOfCancelOrders > 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSize.s24),
                        child: Text(
                          '${state.numOfCancelOrders} order${state.numOfCancelOrders > 1 ? 's' : ''} has been canceled',
                          style: getRegularTextStyle(
                            color: AppColors.lightSalmon,
                            fontSize: AppFontSize.s18.rSp,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: state.numOfCancelOrders > 0,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: AppSize.s32),
                        child: LoadingButton(
                          isLoading: false,
                          verticalPadding: AppSize.s8,
                          onTap: () {
                            _navigateToOrderScreen(data);
                          },
                          text: 'View Orders',
                        ),
                      ),
                    ),
                    Visibility(
                      visible: state.numOfCancelOrders > 0 &&
                          state.numOfNewOrders > 0,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSize.s16),
                        child: Divider(),
                      ),
                    ),
                    Visibility(
                      visible: state.numOfNewOrders > 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSize.s24),
                        child: Text(
                          'You have received ${state.numOfNewOrders} new order${state.numOfNewOrders > 1 ? 's' : ''} ',
                          style: getRegularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s18.rSp,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: state.numOfNewOrders > 0,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: AppSize.s32),
                        child: LoadingButton(
                          isLoading: false,
                          verticalPadding: AppSize.s8,
                          onTap: () {
                            _navigateToOrderScreen(data);
                          },
                          text: 'View Orders',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    ).then((value) {
      _stopSound();
      _isShowing = false;
    });
  }
}
