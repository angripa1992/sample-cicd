import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/entities/order_status.dart';

import '../../../../../core/provider/order_information_provider.dart';
import '../../../domain/usecases/fetch_today_total_orders.dart';

class TodayTotalOrderCubit extends Cubit<ResponseState> {
  final FetchTodayTotalOrders _fetchTotalOrders;
  final OrderInformationProvider _informationProvider;

  TodayTotalOrderCubit(this._fetchTotalOrders, this._informationProvider)
      : super(Empty());

  void fetchTotalOrder({required bool isInitial}) async {
    if(isInitial){
      emit(Loading());
    }
    final status = await _informationProvider.getStatusByNames(
      [OrderStatusName.CANCELLED, OrderStatusName.DELIVERED],
    );
    final brands = await _informationProvider.getBrandsIds();
    final providers = await _informationProvider.getProvidersIds();
    final branch = await _informationProvider.getBranchId();
    final timeZone = await DateTimeProvider.timeZone();
    final params = {
      "start" : DateTimeProvider.today(),
      "end" : DateTimeProvider.nextDay(),
      "timezone" : timeZone,
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands,ListFormat.csv),
      "filterByProvider": ListParam<int>(providers,ListFormat.csv),
      "filterByStatus": ListParam<int>(status,ListFormat.csv),
    };
    final response = await _fetchTotalOrders(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (orders) {
        emit(Success<Orders>(orders));
      },
    );
  }
}
