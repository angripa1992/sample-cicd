import 'package:get_it/get_it.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/user/data/datasource/login_remote_data_source.dart';
import 'package:klikit/modules/user/data/repositories/login_repository_impl.dart';
import 'package:klikit/modules/user/domain/repositories/login_repository.dart';
import 'package:klikit/modules/user/domain/usecases/login_usecases.dart';
import 'package:klikit/modules/user/presentation/bloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/rest_client.dart';
import '../core/network/token_provider.dart';
import '../environment_variables.dart';

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

  //login
  getIt.registerLazySingleton<LoginRemoteDataSource>(() => LoginRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(getIt(),getIt()));
  getIt.registerLazySingleton(() => AuthenticateUser(getIt()));
  getIt.registerFactory(() => LoginBloc(authenticateUser: getIt()));
}
