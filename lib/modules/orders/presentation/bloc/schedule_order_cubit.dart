import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../core/widgets/filter/filter_data.dart';
import '../../../common/oni_parameter_provider.dart';
import '../../domain/entities/order.dart';
import '../../domain/repository/orders_repository.dart';

class ScheduleOrderCubit extends Cubit<ResponseState> {
  final OrderRepository _orderRepository;

  ScheduleOrderCubit(this._orderRepository) : super(Empty());

  void fetchScheduleOrder({required bool willShowLoading, required OniFilteredData? filteredData}) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final params = await OniParameterProvider().scheduleOrder(filteredData: filteredData);
    final response = await _orderRepository.fetchOrder(params);
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
