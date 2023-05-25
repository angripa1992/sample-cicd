import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../data/models/action_success_model.dart';
import '../domain/repository/orders_repository.dart';
import 'grab_order_update_request_model.dart';

class UpdateGrabOrderCubit extends Cubit<ResponseState> {
  final OrderRepository _repository;

  UpdateGrabOrderCubit(this._repository) : super(Empty());

  void updateGrabOrder(GrabOrderUpdateRequestModel model) async {
    emit(Loading());
    final response = await _repository.updateGrabOrder(model);
    response.fold(
      (l) => emit(
        Failed(l),
      ),
      (r) => emit(
        Success<ActionSuccess>(r),
      ),
    );
  }
}
