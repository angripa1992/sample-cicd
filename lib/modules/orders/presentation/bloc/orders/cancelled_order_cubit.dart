import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../core/provider/order_information_provider.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_status.dart';
import '../../../domain/usecases/fetch_cancelled_order.dart';

class CancelledOrderCubit extends Cubit<ResponseState> {
  final FetchCancelledOrder _fetchCancelledOrder;
  final OrderInformationProvider _informationProvider;

  CancelledOrderCubit(this._fetchCancelledOrder, this._informationProvider)
      : super(Empty());

  void fetchTodayCancelledOrder({required bool willShowLoading}) async {
    final timeZone = await DateTimeProvider.timeZone();
    final brands = await _informationProvider.getBrandsIds();
    final providers = await _informationProvider.getProvidersIds();
    final Map<String, dynamic> params = {};
    params["start"] = DateTimeProvider.today();
    params["end"] = DateTimeProvider.nextDay();
    params["timezone"] = timeZone;
    params["filterByBrand"] = ListParam<int>(brands, ListFormat.csv);
    params["filterByProvider"] = ListParam<int>(providers, ListFormat.csv);
    _fetchCancelledOrders(willShowLoading: willShowLoading, params: params);
  }

  void fetchLifeTimeCancelledOrder({
    required bool willShowLoading,
    List<int>? providersID,
    List<int>? brandsID,
  }) async {
    final brands = brandsID ?? await _informationProvider.getBrandsIds();
    final providers = providersID ?? await _informationProvider.getProvidersIds();
    final Map<String, dynamic> params = {};
    if(brands.isNotEmpty){
      params["filterByBrand"] = ListParam<int>(brands, ListFormat.csv);
    }
    if(providers.isNotEmpty){
      params["filterByProvider"] = ListParam<int>(providers, ListFormat.csv);
    }
    _fetchCancelledOrders(willShowLoading: willShowLoading, params: params);
  }

  void _fetchCancelledOrders({
    required bool willShowLoading,
    required Map<String, dynamic> params,
  }) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final status = await _informationProvider.getStatusByNames(
      [OrderStatusName.CANCELLED],
    );
    final branch = await _informationProvider.getBranchId();
    params['filterByStatus'] = ListParam<int>(status, ListFormat.csv);
    params['filterByBranch'] = branch;
    final response = await _fetchCancelledOrder(params);
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
