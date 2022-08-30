import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/user/presentation/bloc/login_event.dart';
import 'package:klikit/modules/user/presentation/bloc/login_state.dart';

import '../../domain/usecases/login_usecases.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticateUser authenticateUser;

  LoginBloc({required this.authenticateUser}) : super(LoginStateEmpty()) {
    on<LoginEventAuthenticate>(_login);
  }

  Future<void> _login(LoginEventAuthenticate event, Emitter<LoginState> emit) async {
    emit(LoginStateLoading());
    final failureOrUser = await authenticateUser(event.loginParams);
    failureOrUser.fold(
      (failure) => emit(LoginStateError(failure)),
      (user) => emit(LoginStateSuccess(user)),
    );
  }
}
