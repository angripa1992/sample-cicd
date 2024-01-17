import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';

import '../../../common/oni_parameter_provider.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_ongoing_order.dart';

class OngoingOrderCubit extends Cubit<ResponseState> {
  final FetchOngoingOrder _fetchOngoingOrder;

  OngoingOrderCubit(this._fetchOngoingOrder) : super(Empty());

  void fetchOngoingOrder({
    required bool willShowLoading,
    required OniFilteredData? filteredData,
  }) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final params = await OniParameterProvider().ongoingOrder(filteredData: filteredData);
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
