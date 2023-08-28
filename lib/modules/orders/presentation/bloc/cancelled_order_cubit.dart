import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../app/session_manager.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_cancelled_order.dart';
import '../../provider/order_information_provider.dart';

class CancelledOrderCubit extends Cubit<ResponseState> {
  final FetchCancelledOrder _fetchCancelledOrder;
  final OrderInformationProvider _informationProvider;

  CancelledOrderCubit(this._fetchCancelledOrder, this._informationProvider)
      : super(Empty());

  void fetchTodayCancelledOrder({required bool willShowLoading}) async {
    final timeZone = await DateTimeProvider.timeZone();
    final brands = await _informationProvider.findBrandsIds();
    final providers = await _informationProvider.findProvidersIds();
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
    _fetchCancelledOrders(willShowLoading: willShowLoading, params: params);
  }

  void _fetchCancelledOrders({
    required bool willShowLoading,
    required Map<String, dynamic> params,
  }) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final status = [OrderStatus.CANCELLED];
    final branch = SessionManager().branchId();
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
