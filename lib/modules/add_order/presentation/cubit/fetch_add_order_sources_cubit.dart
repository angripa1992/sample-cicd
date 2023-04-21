import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../domain/entities/order_source.dart';
import '../../domain/repository/add_order_repository.dart';

class AddOrderSourcesCubit extends Cubit<ResponseState> {
  final AddOrderRepository _repository;

  AddOrderSourcesCubit(this._repository) : super(Empty());

  void fetchSources() async {
    emit(Loading());
    final response = await _repository.fetchSources();
    response.fold(
      (error) {
        emit(Failed(error));
      },
      (success) {
        emit(Success<List<AddOrderSourceType>>(success));
      },
    );
  }
}
