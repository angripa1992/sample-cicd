import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../../core/provider/order_information_provider.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_status.dart';
import '../../../domain/usecases/fetch_new_order.dart';

class NewOrderCubit extends Cubit<ResponseState> {
  final FetchNewOrder _fetchNewOrder;
  final OrderInformationProvider _informationProvider;

  NewOrderCubit(this._fetchNewOrder, this._informationProvider)
      : super(Empty());

  void fetchNewOrder({required bool willShowLoading,List<int>? providersID,List<int>? brandsID}) async {
    if(willShowLoading){
      emit(Loading());
    }
    final status = await _informationProvider.getStatusByNames(
      [OrderStatusName.PLACED, OrderStatusName.ACCEPTED],
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
    final response = await _fetchNewOrder(params);
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
