import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';

import '../../../common/oni_parameter_provider.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_new_order.dart';

class NewOrderCubit extends Cubit<ResponseState> {
  final FetchNewOrder _fetchNewOrder;

  NewOrderCubit(this._fetchNewOrder) : super(Empty());

  void fetchNewOrder({
    required bool willShowLoading,
    required OniFilteredData? filteredData,
  }) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final params = await OniParameterProvider().newOrder(filteredData: filteredData);
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
