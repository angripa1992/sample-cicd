import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../data/model/consumer_protection.dart';
import '../../data/repository/consumer_protection_repository.dart';

class ConsumerProtectionCubit extends Cubit<ResponseState> {
  final ConsumerProtectionRepository _repository;

  ConsumerProtectionCubit(this._repository) : super(Empty());

  void fetchConsumerProtection() async {
    emit(Loading());
    final response = await _repository.fetchConsumerProtectionFakeData();
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<ConsumerProtection?>(data));
      },
    );
  }
}
