import 'package:equatable/equatable.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';

import '../../../../../core/network/error_handler.dart';

abstract class AccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountStateEmpty extends AccountState {}

class AccountStateLoading extends AccountState {}

class AccountStateSuccess<T> extends AccountState {
  final T successResponse;

  AccountStateSuccess(this.successResponse);
}

class AccountStateFailed extends AccountState {
  final Failure failure;

  AccountStateFailed(this.failure);

  @override
  List<Object?> get props => [failure];
}
