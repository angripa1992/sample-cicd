import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/login.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticateUser authenticateUser;

  LoginBloc({required this.authenticateUser}) : super(LoginStateEmpty()) {
    on<LoginEventAuthenticate>(_login);
  }

  Future<void> _login(
      LoginEventAuthenticate event, Emitter<LoginState> emit) async {
    emit(LoginStateLoading());
    final failureOrUser = await authenticateUser(event.loginParams);
    failureOrUser.fold(
      (failure) => emit(LoginStateError(failure)),
      (user) => emit(LoginStateSuccess(user)),
    );
  }
}
