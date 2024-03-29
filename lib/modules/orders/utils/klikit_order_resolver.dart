import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/modules/orders/utils/update_manual_order_data_provider.dart';

import '../../../app/constants.dart';
import '../../../app/di.dart';
import '../../../core/route/routes.dart';
import '../../../printer/printer_manager.dart';
import '../../../resources/strings.dart';
import '../../../segments/event_manager.dart';
import '../../../segments/segemnt_data_provider.dart';
import '../../common/oni_parameter_provider.dart';
import '../../widgets/snackbars.dart';
import '../domain/entities/order.dart';
import '../domain/repository/orders_repository.dart';
import '../presentation/bloc/all_order_cubit.dart';
import '../presentation/bloc/new_order_cubit.dart';
import '../presentation/bloc/ongoing_order_cubit.dart';
import '../presentation/bloc/schedule_order_cubit.dart';
import '../presentation/components/details/cancel_rider_dialog.dart';
import '../presentation/components/dialogs/action_dialogs.dart';
import '../presentation/components/dialogs/add_payment_method_and_status.dart';
import '../presentation/components/dialogs/cancellation_reason.dart';

class KlikitOrderResolver {
  static final _instance = KlikitOrderResolver._internal();

  factory KlikitOrderResolver() => _instance;

  KlikitOrderResolver._internal();

  void editManualOrder(BuildContext context, Order order) {
    try {
      EasyLoading.show();
      getIt.get<UpdateManualOrderDataProvider>().generateCartData(order).then((value) {
        EasyLoading.dismiss();
        _gotoCartScreen(context);
      });
    } on Exception catch (_) {
      EasyLoading.dismiss();
    }
  }

  void _gotoCartScreen(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.addOrder);
  }

  void findRider({
    required BuildContext context,
    required int orderID,
    required VoidCallback onRefresh,
  }) async {
    EasyLoading.show();
    final response = await getIt.get<OrderRepository>().findRider(orderID);
    response.fold(
      (error) {
        EasyLoading.dismiss();
        showApiErrorSnackBar(context, error);
      },
      (success) {
        EasyLoading.dismiss();
        showSuccessSnackBar(context, success.message ?? '');
        onRefresh();
      },
    );
  }

  void onAction({
    required BuildContext context,
    required String sourceTab,
    required String title,
    required Order order,
    required int status,
    required VoidCallback onRefresh,
    bool isFromDetails = false,
  }) {
    if (status == OrderStatus.DELIVERED && order.isManualOrder && order.paymentStatus != PaymentStatusId.paid) {
      showAddPaymentStatusMethodDialog(
        title: AppStrings.select_payment_method_and_status.tr(),
        context: context,
        order: order,
        isWebShopPostPayment: false,
        onSuccess: (method, channel, status) {
          onRefresh();
          if (isFromDetails) {
            Navigator.of(context).pop();
          }
          SegmentManager().trackOrderSegment(
            sourceTab: sourceTab,
            status: status,
            isFromDetails: isFromDetails,
          );
        },
      );
    } else {
      showOrderActionDialog(
        params: OniParameterProvider().getOrderActionParams(order),
        context: context,
        title: title,
        status: status,
        onSuccess: () {
          onRefresh();
          if (isFromDetails) {
            Navigator.of(context).pop();
          }
          if (status == OrderStatus.ACCEPTED && !UserPermissionManager().isBizOwner()) {
            printDocket(order: order, isFromDetails: isFromDetails, sourceTab: sourceTab);
          }
          SegmentManager().trackOrderSegment(
            sourceTab: sourceTab,
            status: status,
            isFromDetails: isFromDetails,
          );
        },
      );
    }
  }

  void cancelOrder({
    required BuildContext context,
    required String sourceTab,
    required String title,
    required Order order,
    required bool isFromDetails,
    required VoidCallback onRefresh,
  }) {
    showCancellationReasonDialog(
        context: context,
        title: title,
        order: order,
        successCallback: () {
          onRefresh();
          if (isFromDetails) {
            Navigator.of(context).pop();
          }
          SegmentManager().trackOrderSegment(
            sourceTab: sourceTab,
            status: OrderStatus.CANCELLED,
            isFromDetails: isFromDetails,
          );
        });
  }

  void printDocket({
    required Order order,
    required bool isFromDetails,
    required String sourceTab,
  }) async{
    if (order.status == OrderStatus.PLACED) {
      await getIt.get<PrinterManager>().doAutoDocketPrinting(order: order, isFromBackground: false);
    } else {
      getIt.get<PrinterManager>().doForegroundManualDocketPrinting(order);
    }
    SegmentManager().trackOrderSegment(
      sourceTab: sourceTab,
      isFromDetails: isFromDetails,
      willPrint: true,
    );
  }

  void refreshOrderCounts(
    BuildContext context, {
    OniFilteredData? filteredData,
  }) {
    context.read<NewOrderCubit>().fetchNewOrder(willShowLoading: false, filteredData: filteredData);
    context.read<OngoingOrderCubit>().fetchOngoingOrder(willShowLoading: false, filteredData: filteredData);
    context.read<AllOrderCubit>().fetchAllOrder(filteredData: filteredData);
    context.read<ScheduleOrderCubit>().fetchScheduleOrder(willShowLoading: false, filteredData: filteredData);
  }

  void sendOrderDetailsScreenEvent(String sourceTab) {
    SegmentManager().screen(
      event: SegmentEvents.SEE_DETAILS,
      name: 'See Details',
      properties: {'source_tab': sourceTab},
    );
  }

  void cancelRider({
    required BuildContext context,
    required Order order,
    required VoidCallback onSuccess,
  }) {
    showCancelRiderDialog(
      context: context,
      order: order,
      successCallback: onSuccess,
    );
  }
}
