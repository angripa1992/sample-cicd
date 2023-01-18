import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../core/provider/order_information_provider.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/usecases/fetch_completed_order.dart';

class CompletedOrderCubit extends Cubit<ResponseState> {
  final FetchCompletedOrder _fetchCompletedOrder;
  final OrderInformationProvider _informationProvider;

  CompletedOrderCubit(this._fetchCompletedOrder, this._informationProvider)
      : super(Empty());

  void fetchTodayCompletedOrder({required bool willShowLoading}) async {
    final timeZone = await DateTimeProvider.timeZone();
    final brands = await _informationProvider.findBrandsIds();
    final providers = await _informationProvider.findProvidersIds();
    final Map<String, dynamic> params = {};
    params["start"] = DateTimeProvider.today();
    params["end"] = DateTimeProvider.nextDay();
    params["timezone"] = timeZone;
    params["filterByBrand"] = ListParam<int>(brands, ListFormat.csv);
    params["filterByProvider"] = ListParam<int>(providers, ListFormat.csv);
    _fetchCompletedOrders(willShowLoading: willShowLoading, params: params);
  }

  void fetchLifeTimeCompletedOrder({
    required bool willShowLoading,
    List<int>? providersID,
    List<int>? brandsID,
  }) async {
    final brands = brandsID ?? await _informationProvider.findBrandsIds();
    final providers =
        providersID ?? await _informationProvider.findProvidersIds();
    final Map<String, dynamic> params = {};
    if (brands.isNotEmpty) {
      params["filterByBrand"] = ListParam<int>(brands, ListFormat.csv);
    }
    if (providers.isNotEmpty) {
      params["filterByProvider"] = ListParam<int>(providers, ListFormat.csv);
    }
    _fetchCompletedOrders(willShowLoading: willShowLoading, params: params);
  }

  void _fetchCompletedOrders({
    required bool willShowLoading,
    required Map<String, dynamic> params,
  }) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final status = [OrderStatus.DELIVERED,OrderStatus.PICKED_UP];
    final branch = await _informationProvider.findBranchId();
    params['filterByStatus'] = ListParam<int>(status, ListFormat.csv);
    params['filterByBranch'] = branch;
    final response = await _fetchCompletedOrder(params);
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
