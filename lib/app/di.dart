import 'package:get_it/get_it.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/user/data/datasource/user_remote_data_source.dart';
import 'package:klikit/modules/user/data/repositories/user_repository_impl.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';
import 'package:klikit/modules/user/domain/usecases/login_usecases.dart';
import 'package:klikit/modules/user/domain/usecases/logout_usecase.dart';
import 'package:klikit/modules/user/domain/usecases/send_reset_link.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/modules/user/presentation/account/cubit/update_user_info_cubit.dart';
import 'package:klikit/modules/user/presentation/forget/cubit/forget_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/rest_client.dart';
import '../core/network/token_provider.dart';
import '../environment_variables.dart';
import '../modules/user/presentation/login/bloc/login_bloc.dart';

final getIt = GetIt.instance;

Future<void> initAppModule(EnvironmentVariables environmentVariables) async {
  getIt.registerSingleton<EnvironmentVariables>(environmentVariables);
  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  getIt.registerSingleton<AppPreferences>(AppPreferences(getIt()));
  getIt.registerSingleton<TokenProvider>(TokenProvider(getIt()));
  getIt.registerSingleton<RestClient>(RestClient(getIt()));
  getIt.registerSingleton<NetworkConnectivity>(NetworkConnectivity());

  ///user
  getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt(),getIt()));
  getIt.registerLazySingleton(() => AuthenticateUser(getIt()));
  getIt.registerFactory(() => LoginBloc(authenticateUser: getIt()));
  getIt.registerLazySingleton(() => LogoutUser(getIt()));
  getIt.registerFactory(() => LogoutCubit(getIt()));
  getIt.registerLazySingleton(() => UpdateUserInfo(getIt()));
  getIt.registerFactory(() => UpdateUserInfoCubit(getIt()));
  getIt.registerLazySingleton(() => SentResetLink(getIt()));
  getIt.registerFactory(() => ForgetPasswordCubit(getIt()));
}
