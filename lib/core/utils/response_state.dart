import 'package:equatable/equatable.dart';
import 'package:klikit/core/network/error_handler.dart';

abstract class ResponseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends ResponseState {
  @override
  List<Object?> get props => [];
}

class Loading extends ResponseState {
  @override
  List<Object?> get props => [];
}

class Success<T> extends ResponseState {
  final T data;

  Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Failed extends ResponseState {
  final Failure failure;

  Failed(this.failure);

  @override
  List<Object?> get props => [failure];
}
