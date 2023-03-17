import 'package:get_it/get_it.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/modules/add_order/data/datasource/add_order_datasource.dart';
import 'package:klikit/modules/add_order/data/repository/add_order_repository_impl.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/menu/data/datasource/menu_remote_datasource.dart';
import 'package:klikit/modules/menu/data/repository/menu_repository_impl.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';
import 'package:klikit/modules/menu/domain/usecase/check_affected.dart';
import 'package:klikit/modules/menu/domain/usecase/fetch_menu_brands.dart';
import 'package:klikit/modules/menu/domain/usecase/fetch_menus.dart';
import 'package:klikit/modules/menu/domain/usecase/ftech_modifier_groups.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/menu/domain/usecase/update_modifier.dart';
import 'package:klikit/modules/menu/presentation/cubit/brand_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/check_affected_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/menu_brands_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/modifier_groups_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/tab_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_item_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_menu_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_modifier_cubit.dart';
import 'package:klikit/modules/orders/data/datasource/orders_remote_datasource.dart';
import 'package:klikit/modules/orders/data/repository/orders_repository_impl.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/domain/usecases/add_comment.dart';
import 'package:klikit/modules/orders/domain/usecases/check_busy_mode.dart';
import 'package:klikit/modules/orders/domain/usecases/delete_comment.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_cancelled_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_completed_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_new_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_ongoing_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_total_orders.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_yesterday_total_order.dart';
import 'package:klikit/modules/orders/domain/usecases/update_busy_mode_status.dart';
import 'package:klikit/modules/orders/domain/usecases/update_order_status.dart';
import 'package:klikit/modules/orders/provider/order_information_provider.dart';
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
import 'package:klikit/notification/fcm_token_manager.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/data/printer_setting_repo.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';
import 'package:klikit/printer/printing_handler.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consumer_protection/data/repository/consumer_protection_repository.dart';
import '../consumer_protection/presentation/cubit/consumer_protection_cubit.dart';
import '../core/network/rest_client.dart';
import '../core/network/token_provider.dart';
import '../core/provider/location_provider.dart';
import '../environment_variables.dart';
import '../language/language_manager.dart';
import '../modules/add_order/presentation/cubit/fetch_sub_section_cubit.dart';
import '../modules/base/chnage_language_cubit.dart';
import '../modules/menu/presentation/cubit/aggregator_selection_cubit.dart';
import '../modules/orders/data/repository/order_info_provider_repo_impl.dart';
import '../modules/orders/domain/repository/order_info_provider_repo.dart';
import '../modules/orders/presentation/bloc/add_comment_cubit.dart';
import '../modules/orders/presentation/bloc/busy_mode_cubit.dart';
import '../modules/orders/presentation/bloc/cancelled_order_cubit.dart';
import '../modules/orders/presentation/bloc/completed_order_cubit.dart';
import '../modules/orders/presentation/bloc/delete_comment_cubit.dart';
import '../modules/orders/presentation/bloc/new_order_cubit.dart';
import '../modules/orders/presentation/bloc/ongoing_order_cubit.dart';
import '../modules/orders/presentation/bloc/order_action_cubit.dart';
import '../modules/orders/presentation/bloc/schedule_order_cubit.dart';
import '../modules/orders/presentation/bloc/total_order_cubit.dart';
import '../modules/orders/presentation/bloc/update_busy_mode_cubit.dart';
import '../modules/orders/presentation/bloc/yesterday_total_order_cubit.dart';
import '../modules/orders/provider/order_parameter_provider.dart';
import '../modules/user/presentation/login/bloc/login_bloc.dart';
import '../segments/segemnt_data_provider.dart';

final getIt = GetIt.instance;

Future<void> initAppModule(EnvironmentVariables environmentVariables) async {
  getIt.registerSingleton<EnvironmentVariables>(environmentVariables);
  getIt.registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance());
  getIt.registerSingleton<DeviceInfoProvider>(DeviceInfoProvider());
  getIt.registerSingleton<LocationProvider>(LocationProvider());
  getIt.registerSingleton<AppPreferences>(AppPreferences(getIt()));
  getIt.registerSingleton<SegmentDataProvider>(
      SegmentDataProvider(getIt(), getIt()));
  getIt.registerSingleton<LanguageManager>(LanguageManager(getIt()));
  getIt.registerSingleton<TokenProvider>(TokenProvider());
  getIt.registerSingleton<RestClient>(RestClient(getIt()));
  getIt.registerSingleton<NetworkConnectivity>(NetworkConnectivity());
  getIt.registerSingleton<FcmTokenManager>(
      FcmTokenManager(getIt.get(), getIt.get()));

  ///base
  getIt.registerFactory(() => BaseScreenCubit());
  getIt.registerFactory(() => ChangeLanguageCubit());

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
  getIt.registerLazySingleton<OrderInfoProviderRepo>(
      () => OrderInfoProviderRepoImpl(getIt(), getIt()));
  getIt.registerLazySingleton(() => OrderInformationProvider(getIt()));
  getIt.registerLazySingleton(() => OrderParameterProvider(getIt()));
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(getIt(), getIt(), getIt()));
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
  getIt.registerFactory(() => ScheduleOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchOngoingOrder(getIt()));
  getIt.registerFactory(() => OngoingOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => UpdateOrderStatus(getIt()));
  getIt.registerFactory(() => OrderActionCubit(getIt()));
  getIt.registerLazySingleton(() => AddComment(getIt()));
  getIt.registerLazySingleton(() => DeleteComment(getIt()));
  getIt.registerFactory(() => AddCommentCubit(getIt()));
  getIt.registerFactory(() => DeleteCommentCubit(getIt()));

  ///busy mode
  getIt.registerLazySingleton(() => CheckBusyMode(getIt()));
  getIt.registerLazySingleton(() => UpdateBusyModeStatus(getIt()));
  getIt.registerFactory(() => BusyModeCubit(getIt()));
  getIt.registerFactory(() => UpdateBusyModeCubit(getIt()));

  ///menu mgt
  getIt.registerLazySingleton<MenuRemoteDatasource>(() => MenuRemoteDatasourceImpl(getIt.get()));
  getIt.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(getIt.get(), getIt.get()));
  getIt.registerLazySingleton(() => FetchMenuBrands(getIt.get()));
  getIt.registerFactory(() => MenuBrandsCubit(getIt.get()));
  getIt.registerFactory(() => BrandSelectionCubit());
  getIt.registerFactory(() => TabSelectionCubit());
  getIt.registerLazySingleton(() => FetchMenus(getIt.get()));
  getIt.registerFactory(() => MenusCubit(getIt.get()));
  getIt.registerLazySingleton(() => UpdateItem(getIt.get()));
  getIt.registerFactory(() => UpdateItemCubit(getIt.get()));
  getIt.registerLazySingleton(() => UpdateMenu(getIt.get()));
  getIt.registerFactory(() => UpdateMenuCubit(getIt.get()));
  getIt.registerLazySingleton(() => FetchModifierGroups(getIt.get()));
  getIt.registerFactory(() => ModifierGroupsCubit(getIt.get()));
  getIt.registerLazySingleton(() => CheckAffected(getIt.get()));
  getIt.registerFactory(() => CheckAffectedCubit(getIt.get(), getIt.get()));
  getIt.registerLazySingleton(() => UpdateModifier(getIt.get()));
  getIt.registerFactory(() => UpdateModifierCubit(getIt.get(), getIt.get()));
  getIt.registerFactory(() => AggregatorSelectionCubit());

  ///printer
  getIt.registerLazySingleton(() => BluetoothPrinterHandler());
  getIt.registerLazySingleton(() => UsbPrinterHandler());
  getIt.registerLazySingleton(() =>
      PrintingHandler(getIt.get(), getIt.get(), getIt.get(), getIt.get()));
  getIt.registerLazySingleton<PrinterSettingRepository>(
      () => PrinterSettingRepositoryImpl(getIt.get(), getIt.get()));
  getIt.registerFactory(() => PrinterSettingCubit(getIt.get()));
  getIt.registerFactory(() => UpdatePrinterSettingCubit(getIt.get()));

  ///consumer protection
  getIt.registerLazySingleton<ConsumerProtectionRepository>(() => ConsumerProtectionRepositoryImpl(getIt.get(), getIt.get()));
  getIt.registerFactory(() => ConsumerProtectionCubit(getIt.get()));

  //add order
  getIt.registerLazySingleton<AddOrderDatasource>(() => AddOrderDatasourceImpl(getIt()));
  getIt.registerLazySingleton<AddOrderRepository>(() => AddOrderRepositoryImpl(getIt(),getIt()));
  getIt.registerFactory(() => FetchSubSectionCubit(getIt.get()));
}
