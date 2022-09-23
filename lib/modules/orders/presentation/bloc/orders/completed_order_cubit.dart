import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../core/provider/order_information_provider.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_status.dart';
import '../../../domain/usecases/fetch_completed_order.dart';

class CompletedOrderCubit extends Cubit<ResponseState> {
  final FetchCompletedOrder _fetchCompletedOrder;
  final OrderInformationProvider _informationProvider;

  CompletedOrderCubit(this._fetchCompletedOrder, this._informationProvider)
      : super(Empty());

  void fetchCompletedOrder({required bool isInitial}) async {
    if(isInitial){
      emit(Loading());
    }
    final status = await _informationProvider.getStatusByNames(
      [OrderStatusName.DELIVERED],
    );
    final brands = await _informationProvider.getBrandsIds();
    final providers = await _informationProvider.getProvidersIds();
    final branch = await _informationProvider.getBranchId();
    final timeZone = await DateTimeProvider.timeZone();
    final params = {
      "start": DateTimeProvider.today(),
      "end": DateTimeProvider.today(),
      "timezone": timeZone,
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands,ListFormat.csv),
      "filterByProvider": ListParam<int>(providers,ListFormat.csv),
      "filterByStatus": ListParam<int>(status,ListFormat.csv),
    };
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
