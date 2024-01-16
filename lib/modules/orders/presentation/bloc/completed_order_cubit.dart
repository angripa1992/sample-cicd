import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../app/session_manager.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_completed_order.dart';
import '../../../common/business_information_provider.dart';

class CompletedOrderCubit extends Cubit<ResponseState> {
  final FetchCompletedOrder _fetchCompletedOrder;
  final BusinessInformationProvider _informationProvider;

  CompletedOrderCubit(this._fetchCompletedOrder, this._informationProvider)
      : super(Empty());

  void fetchTodayCompletedOrder({required bool willShowLoading}) async {
    final timeZone = await DateTimeFormatter.timeZone();
    final brands = await _informationProvider.fetchBrandsIds();
    final providers = await _informationProvider.findProvidersIds();
    final Map<String, dynamic> params = {};
    params["start"] = DateTimeFormatter.today();
    params["end"] = DateTimeFormatter.nextDay();
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
    final brands = brandsID ?? await _informationProvider.fetchBrandsIds();
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
    final status = [OrderStatus.DELIVERED, OrderStatus.PICKED_UP];
    final branch = SessionManager().branchId();
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
