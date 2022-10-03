import 'package:get_it/get_it.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/core/network/web_socket_client.dart';
import 'package:klikit/core/provider/order_information_provider.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/orders/data/datasource/orders_remote_datasource.dart';
import 'package:klikit/modules/orders/data/repository/orders_repository_impl.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/domain/usecases/check_busy_mode.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_cancelled_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_completed_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_new_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_ongoing_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_total_orders.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_yesterday_total_order.dart';
import 'package:klikit/modules/orders/domain/usecases/update_busy_mode_status.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/update_busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/cancelled_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/new_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/ongoing_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/user/data/datasource/user_remote_data_source.dart';
import 'package:klikit/modules/user/data/repositories/user_repository_impl.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';
import 'package:klikit/modules/user/domain/usecases/chnage_password.dart';
import 'package:klikit/modules/user/domain/usecases/login.dart';
import 'package:klikit/modules/user/domain/usecases/logout.dart';
import 'package:klikit/modules/user/domain/usecases/send_reset_link.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/modules/user/presentation/account/cubit/update_user_info_cubit.dart';
import 'package:klikit/modules/user/presentation/chnage_password/cubit/change_password_cubit.dart';
import 'package:klikit/modules/user/presentation/forget/cubit/forget_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/rest_client.dart';
import '../core/network/token_provider.dart';
import '../environment_variables.dart';
import '../modules/orders/presentation/bloc/orders/completed_order_cubit.dart';
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
  getIt.registerSingleton<WebSocketClient>(WebSocketClient(getIt()));

  ///base
  getIt.registerFactory(() => BaseScreenCubit());

  ///user
  getIt.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton(() => AuthenticateUser(getIt()));
  getIt.registerFactory(() => LoginBloc(authenticateUser: getIt()));
  getIt.registerLazySingleton(() => LogoutUser(getIt()));
  getIt.registerFactory(() => LogoutCubit(getIt()));
  getIt.registerLazySingleton(() => UpdateUserInfo(getIt()));
  getIt.registerFactory(() => UpdateUserInfoCubit(getIt()));
  getIt.registerLazySingleton(() => SentResetLink(getIt()));
  getIt.registerFactory(() => ForgetPasswordCubit(getIt()));
  getIt.registerLazySingleton(() => ChangePassword(getIt()));
  getIt.registerFactory(() => ChangePasswordCubit(getIt(), getIt()));

  ///order
  getIt.registerLazySingleton<OrderRemoteDatasource>(
      () => OrderRemoteDatasourceImpl(getIt()));
  getIt.registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(getIt(), getIt()));
  getIt.registerLazySingleton(() => OrderInformationProvider(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchTotalOrders(getIt()));
  getIt.registerFactory(() => TotalOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchYesterdayTotalOrders(getIt()));
  getIt.registerFactory(() => YesterdayTotalOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchCompletedOrder(getIt()));
  getIt.registerFactory(() => CompletedOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchCancelledOrder(getIt()));
  getIt.registerFactory(() => CancelledOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchNewOrder(getIt()));
  getIt.registerFactory(() => NewOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchOngoingOrder(getIt()));
  getIt.registerFactory(() => OngoingOrderCubit(getIt(), getIt()));

  ///busy mode
  getIt.registerLazySingleton(() => CheckBusyMode(getIt()));
  getIt.registerLazySingleton(() => UpdateBusyModeStatus(getIt()));
  getIt.registerFactory(() => BusyModeCubit(getIt(), getIt(),));
  getIt.registerFactory(() => UpdateBusyModeCubit(getIt(), getIt(),));
}
