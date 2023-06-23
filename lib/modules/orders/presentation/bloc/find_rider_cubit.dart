import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../domain/repository/orders_repository.dart';

class FindRiderCubit extends Cubit<ResponseState> {
  final OrderRepository _orderRepository;

  FindRiderCubit(this._orderRepository) : super(Empty());

  void findRider(int id) async {
    emit(Loading());
    final response = await _orderRepository.findRider(id);
    response.fold(
      (error) => emit(
        Failed(error),
      ),
      (success) => emit(
        Success<ActionSuccess>(success),
      ),
    );
  }
}
