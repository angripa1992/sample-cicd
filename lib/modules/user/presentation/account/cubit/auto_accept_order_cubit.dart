import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/user/domain/entities/auto_accept_order.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';

import '../../../../../app/session_manager.dart';

abstract class AutoAcceptState {}

class InitialState extends AutoAcceptState {}

class LoadingState extends AutoAcceptState {}

class FetchedState extends AutoAcceptState {
  final AutoAcceptOrder success;

  FetchedState(this.success);
}

class ToggleSuccessState extends AutoAcceptState {
  final AutoAcceptOrder success;

  ToggleSuccessState(this.success);
}

class FailedState extends AutoAcceptState {
  final Failure failure;

  FailedState(this.failure);
}

class AutoAcceptOrderCubit extends Cubit<AutoAcceptState> {
  final UserRepository _repository;

  AutoAcceptOrderCubit(this._repository) : super(InitialState());

  void fetchPreference() async {
    emit(LoadingState());
    final params = {
      "branch_id": SessionManager().user()!.branchIDs.first,
    };
    final response = await _repository.fetchAutoAcceptStatus(params);
    response.fold(
      (error) {
        emit(FailedState(error));
      },
      (success) async {
        emit(FetchedState(success));
      },
    );
  }

  void togglePreference(bool enable) async {
    emit(LoadingState());
    final params = {
      "branch_id": SessionManager().user()!.branchIDs.first,
      "auto_accept": enable,
    };
    final response = await _repository.toggleAutoAccept(params);
    response.fold(
      (error) {
        emit(FailedState(error));
      },
      (success) async {
        emit(ToggleSuccessState(success));
      },
    );
  }
}
