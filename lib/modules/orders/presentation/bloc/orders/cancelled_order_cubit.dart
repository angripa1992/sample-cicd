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

  void fetchCancelledOrder() async {
    emit(Loading());
    final status = await _informationProvider.getStatusByNames(
      [OrderStatusName.CANCELLED],
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
