import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../../core/provider/order_information_provider.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_status.dart';
import '../../../domain/usecases/fetch_ongoing_order.dart';

class OngoingOrderCubit extends Cubit<ResponseState> {
  final FetchOngoingOrder _fetchOngoingOrder;
  final OrderInformationProvider _informationProvider;

  OngoingOrderCubit(this._fetchOngoingOrder, this._informationProvider)
      : super(Empty());

  void fetchOngoingOrder({required bool willShowLoading,List<int>? providersID,List<int>? brandsID}) async {
    if(willShowLoading){
      emit(Loading());
    }
    final status = await _informationProvider.getStatusByNames(
      [
        OrderStatusName.PLACED,
        OrderStatusName.ACCEPTED,
        OrderStatusName.READY,
        OrderStatusName.SCHEDULED,
        OrderStatusName.DRIVER_ASSIGNED,
        OrderStatusName.DRIVER_ARRIVED,
        OrderStatusName.PICKED_UP,
      ],
    );
    final brands = brandsID ?? await _informationProvider.getBrandsIds();
    final providers = providersID ?? await _informationProvider.getProvidersIds();
    final branch = await _informationProvider.getBranchId();
    final params = {
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands,ListFormat.csv),
      "filterByProvider": ListParam<int>(providers,ListFormat.csv),
      "filterByStatus": ListParam<int>(status,ListFormat.csv),
    };
    final response = await _fetchOngoingOrder(params);
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
