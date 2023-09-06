import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../domain/entity/pause_store_data.dart';
import '../../domain/repository/pause_store_repository.dart';

class FetchPauseStoreDataCubit extends Cubit<ResponseState> {
  final PauseStoreRepository _repository;

  FetchPauseStoreDataCubit(this._repository) : super(Empty());

  void fetchPauseStoreData() async {
    final response = await _repository.fetchPauseStoresData(SessionManager().branchId());
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<PauseStoresData>(data));
      },
    );
  }
}
