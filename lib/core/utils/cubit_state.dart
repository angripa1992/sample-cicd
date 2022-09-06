import 'package:equatable/equatable.dart';
import 'package:klikit/core/network/error_handler.dart';

abstract class CubitState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Empty extends CubitState {
  @override
  List<Object?> get props => [];
}

class Loading extends CubitState {
  @override
  List<Object?> get props => [];
}

class Success<T> extends CubitState {
  final T data;

  Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Failed extends CubitState {
  final Failure failure;

  Failed(this.failure);

  @override
  List<Object?> get props => [failure];
}
