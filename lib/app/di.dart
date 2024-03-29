import 'package:get_it/get_it.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/core/utils/socket_handler.dart';
import 'package:klikit/modules/add_order/data/datasource/add_order_datasource.dart';
import 'package:klikit/modules/add_order/data/repository/add_order_repository_impl.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/cubit/update_webshop_order_cubit.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/data/business_remote_datasource.dart';
import 'package:klikit/modules/home/presentation/cubit/order_summary_cubit.dart';
import 'package:klikit/modules/menu/data/datasource/menu_remote_datasource.dart';
import 'package:klikit/modules/menu/data/repository/menu_repository_impl.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';
import 'package:klikit/modules/menu/domain/usecase/check_affected.dart';
import 'package:klikit/modules/menu/domain/usecase/fetch_menus.dart';
import 'package:klikit/modules/menu/domain/usecase/ftech_modifier_groups.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item_snooze.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu_enabled.dart';
import 'package:klikit/modules/menu/domain/usecase/update_modifier_enabled.dart';
import 'package:klikit/modules/menu/presentation/cubit/check_affected_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/fetch_modifier_groups_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/menu_brands_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_item_snooze_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_menu_enabled_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_modifier_enabled_cubit.dart';
import 'package:klikit/modules/orders/data/datasource/orders_remote_datasource.dart';
import 'package:klikit/modules/orders/data/repository/orders_repository_impl.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/domain/usecases/add_comment.dart';
import 'package:klikit/modules/orders/domain/usecases/delete_comment.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_cancelled_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_completed_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_new_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_ongoing_order.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_total_orders.dart';
import 'package:klikit/modules/orders/domain/usecases/fetch_yesterday_total_order.dart';
import 'package:klikit/modules/orders/domain/usecases/update_order_status.dart';
import 'package:klikit/modules/orders/presentation/bloc/cancel_rider_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/update_prep_time_cubit.dart';
import 'package:klikit/modules/orders/utils/update_webshop_order_data_provider.dart';
import 'package:klikit/modules/user/data/datasource/user_remote_data_source.dart';
import 'package:klikit/modules/user/data/repositories/user_repository_impl.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';
import 'package:klikit/modules/user/domain/usecases/chnage_password.dart';
import 'package:klikit/modules/user/domain/usecases/login.dart';
import 'package:klikit/modules/user/domain/usecases/logout.dart';
import 'package:klikit/modules/user/domain/usecases/send_reset_link.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';
import 'package:klikit/modules/user/presentation/account/cubit/auto_accept_order_cubit.dart';
import 'package:klikit/modules/user/presentation/account/cubit/logout_cubit.dart';
import 'package:klikit/modules/user/presentation/account/cubit/update_user_info_cubit.dart';
import 'package:klikit/modules/user/presentation/chnage_password/cubit/change_password_cubit.dart';
import 'package:klikit/modules/user/presentation/forget/cubit/forget_cubit.dart';
import 'package:klikit/notification/fcm_token_manager.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/data/printer_setting_repo.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/presentation/update_printer_setting_cubit.dart';
import 'package:klikit/printer/printer_manager.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consumer_protection/data/repository/consumer_protection_repository.dart';
import '../consumer_protection/presentation/cubit/consumer_protection_cubit.dart';
import '../core/network/rest_client.dart';
import '../core/network/token_provider.dart';
import '../core/provider/location_provider.dart';
import '../env/environment_variables.dart';
import '../language/language_manager.dart';
import '../modules/add_order/presentation/cubit/calculate_bill_cubit.dart';
import '../modules/add_order/presentation/cubit/fetch_menu_items_cubit.dart';
import '../modules/add_order/presentation/cubit/place_order_cubit.dart';
import '../modules/base/chnage_language_cubit.dart';
import '../modules/busy/data/datasource/pause_store_datasource.dart';
import '../modules/busy/data/repository/pause_store_repository.dart';
import '../modules/busy/domain/repository/pause_store_repository.dart';
import '../modules/busy/presentation/bloc/fetch_pause_store_data_cubit.dart';
import '../modules/common/data/business_info_provider_repo.dart';
import '../modules/common/data/business_info_provider_repo_impl.dart';
import '../modules/home/data/datasource/home_data_source.dart';
import '../modules/home/data/repository/home_repository_impl.dart';
import '../modules/home/domain/repository/home_repository.dart';
import '../modules/home/presentation/cubit/fetch_zreport_cubit.dart';
import '../modules/orders/edit_order/calculate_grab_order_cubit.dart';
import '../modules/orders/edit_order/update_grab_order_cubit.dart';
import '../modules/orders/presentation/bloc/add_comment_cubit.dart';
import '../modules/orders/presentation/bloc/all_order_cubit.dart';
import '../modules/orders/presentation/bloc/cancelled_order_cubit.dart';
import '../modules/orders/presentation/bloc/completed_order_cubit.dart';
import '../modules/orders/presentation/bloc/delete_comment_cubit.dart';
import '../modules/orders/presentation/bloc/new_order_cubit.dart';
import '../modules/orders/presentation/bloc/ongoing_order_cubit.dart';
import '../modules/orders/presentation/bloc/order_action_cubit.dart';
import '../modules/orders/presentation/bloc/schedule_order_cubit.dart';
import '../modules/orders/presentation/bloc/total_order_cubit.dart';
import '../modules/orders/presentation/bloc/update_payment_info_cubit.dart';
import '../modules/orders/presentation/bloc/yesterday_total_order_cubit.dart';
import '../modules/orders/utils/update_manual_order_data_provider.dart';
import '../modules/user/presentation/account/cubit/change_notificcation_setting_cubit.dart';
import '../modules/user/presentation/account/cubit/device_setting_cubit.dart';
import '../modules/user/presentation/login/bloc/login_bloc.dart';
import '../segments/segemnt_data_provider.dart';

final getIt = GetIt.instance;

Future<void> initAppModule(EnvironmentVariables environmentVariables) async {
  getIt.registerSingleton<EnvironmentVariables>(environmentVariables);
  getIt.registerSingleton<DeviceInfoProvider>(DeviceInfoProvider());
  getIt.registerSingleton<LocationProvider>(LocationProvider());
  await registerLocalDB();
  getIt.registerSingleton<SegmentDataProvider>(SegmentDataProvider(getIt(), getIt()));
  getIt.registerSingleton<LanguageManager>(LanguageManager(getIt()));
  getIt.registerSingleton<TokenProvider>(TokenProvider());
  getIt.registerSingleton<RestClient>(RestClient(getIt()));
  getIt.registerSingleton<NetworkConnectivity>(NetworkConnectivity());
  getIt.registerSingleton<FcmTokenManager>(FcmTokenManager(getIt.get(), getIt.get()));

  ///base
  getIt.registerFactory(() => BaseScreenCubit());
  getIt.registerFactory(() => ChangeLanguageCubit());

  ///user
  getIt.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt(), getIt()));
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
  getIt.registerFactory(() => ChangeNotificationSettingCubit(getIt()));
  getIt.registerFactory(() => DeviceSettingCubit(getIt()));
  getIt.registerFactory(() => AutoAcceptOrderCubit(getIt()));

  ///pause store
  getIt.registerLazySingleton<PauseStoreRemoteDataSource>(() => PauseStoreRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<PauseStoreRepository>(() => PauseStoreRepositoryImpl(getIt(), getIt()));
  getIt.registerFactory(() => FetchPauseStoreDataCubit(getIt()));

  ///home
  getIt.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt(), getIt()));
  getIt.registerFactory(() => FetchZReportCubit(getIt()));

  ///order
  getIt.registerLazySingleton<OrderRemoteDatasource>(() => OrderRemoteDatasourceImpl(getIt()));
  getIt.registerLazySingleton<BusinessRemoteDataSource>(() => BusinessRemoteDataSourceImpl(getIt()));
  getIt.registerLazySingleton<BusinessInfoProviderRepo>(() => BusinessInfoProviderRepoImpl(getIt(), getIt()));
  getIt.registerLazySingleton(() => BusinessInformationProvider(getIt()));
  getIt.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(getIt(), getIt(), getIt()));
  getIt.registerFactory(() => OrderSummaryCubit(getIt()));
  getIt.registerLazySingleton(() => FetchTotalOrders(getIt()));
  getIt.registerFactory(() => TotalOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchYesterdayTotalOrders(getIt()));
  getIt.registerFactory(() => YesterdayTotalOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchCompletedOrder(getIt()));
  getIt.registerFactory(() => CompletedOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchCancelledOrder(getIt()));
  getIt.registerFactory(() => CancelledOrderCubit(getIt(), getIt()));
  getIt.registerLazySingleton(() => FetchNewOrder(getIt()));
  getIt.registerFactory(() => NewOrderCubit(getIt()));
  getIt.registerFactory(() => AllOrderCubit(getIt()));
  getIt.registerFactory(() => ScheduleOrderCubit(getIt()));
  getIt.registerLazySingleton(() => FetchOngoingOrder(getIt()));
  getIt.registerFactory(() => OngoingOrderCubit(getIt()));
  getIt.registerLazySingleton(() => UpdateOrderStatus(getIt()));
  getIt.registerFactory(() => OrderActionCubit(getIt()));
  getIt.registerFactory(() => UpdatePaymentInfoCubit(getIt()));
  getIt.registerLazySingleton(() => AddComment(getIt()));
  getIt.registerLazySingleton(() => DeleteComment(getIt()));
  getIt.registerFactory(() => AddCommentCubit(getIt()));
  getIt.registerFactory(() => DeleteCommentCubit(getIt()));
  getIt.registerFactory(() => CalculateGrabBillCubit(getIt()));
  getIt.registerFactory(() => UpdateWebShopOrderCubit(getIt()));
  getIt.registerFactory(() => UpdateGrabOrderCubit(getIt()));
  getIt.registerLazySingleton(() => UpdateWebShopOrderDataProvider(getIt()));
  getIt.registerLazySingleton(() => UpdateManualOrderDataProvider(getIt()));
  getIt.registerFactory(() => UpdatePrepTimeCubit(getIt()));
  getIt.registerFactory(() => CancelRiderCubit(getIt()));

  ///menu mgt
  getIt.registerLazySingleton<MenuRemoteDatasource>(() => MenuRemoteDatasourceImpl(getIt.get()));
  getIt.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(getIt.get(), getIt.get()));
  getIt.registerFactory(() => MenuBrandsCubit(getIt.get()));
  getIt.registerLazySingleton(() => FetchMenus(getIt.get()));
  getIt.registerFactory(() => MenusCubit(getIt.get()));
  getIt.registerLazySingleton(() => UpdateItemSnooze(getIt.get()));
  getIt.registerFactory(() => UpdateItemSnoozeCubit(getIt.get()));
  getIt.registerLazySingleton(() => UpdateMenuEnabled(getIt.get()));
  getIt.registerFactory(() => UpdateMenuEnabledCubit(getIt.get()));
  getIt.registerLazySingleton(() => FetchModifierGroups(getIt.get()));
  getIt.registerFactory(() => FetchModifierGroupsCubit(getIt.get()));
  getIt.registerLazySingleton(() => CheckAffected(getIt.get()));
  getIt.registerFactory(() => CheckAffectedCubit(getIt.get()));
  getIt.registerLazySingleton(() => UpdateModifierEnabled(getIt.get()));
  getIt.registerFactory(() => UpdateModifierEnabledCubit(getIt.get()));

  ///printer
  getIt.registerLazySingleton(() => BluetoothPrinterHandler());
  getIt.registerLazySingleton(() => UsbPrinterHandler());
  getIt.registerLazySingleton(() => PrinterManager(getIt.get(), getIt.get()));
  getIt.registerLazySingleton<PrinterSettingRepository>(() => PrinterSettingRepositoryImpl(getIt.get(), getIt.get()));
  getIt.registerFactory(() => PrinterSettingCubit(getIt.get()));
  getIt.registerFactory(() => UpdatePrinterSettingCubit(getIt.get()));

  ///consumer protection
  getIt.registerLazySingleton<ConsumerProtectionRepository>(() => ConsumerProtectionRepositoryImpl(getIt.get(), getIt.get()));
  getIt.registerFactory(() => ConsumerProtectionCubit(getIt.get()));

  ///add order
  getIt.registerLazySingleton<AddOrderDatasource>(() => AddOrderDatasourceImpl(getIt()));
  getIt.registerLazySingleton<AddOrderRepository>(() => AddOrderRepositoryImpl(getIt(), getIt()));
  getIt.registerFactory(() => FetchAddOrderMenuItemsCubit(getIt.get()));
  getIt.registerFactory(() => CalculateBillCubit(getIt.get()));
  getIt.registerFactory(() => PlaceOrderCubit(getIt.get()));
  //socket
  getIt.registerLazySingleton<SocketHandler>(() => SocketHandler(getIt(),getIt(),getIt()));
}

Future<void> registerLocalDB() async {
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
  }
  if (!getIt.isRegistered<AppPreferences>()) {
    getIt.registerSingleton<AppPreferences>(AppPreferences(getIt()));
  }
}

Future<void> registerBackground(EnvironmentVariables environmentVariables) async {
  if (!getIt.isRegistered<EnvironmentVariables>()) {
    getIt.registerSingleton<EnvironmentVariables>(environmentVariables);
  }
  await registerLocalDB();
  await getIt.get<AppPreferences>().reload();

  if (!getIt.isRegistered<DeviceInfoProvider>()) {
    getIt.registerSingleton<DeviceInfoProvider>(DeviceInfoProvider());
  }

  if (!getIt.isRegistered<TokenProvider>()) {
    getIt.registerSingleton<TokenProvider>(TokenProvider());
  }

  if (!getIt.isRegistered<RestClient>()) {
    getIt.registerSingleton<RestClient>(RestClient(getIt()));
  }

  if (!getIt.isRegistered<NetworkConnectivity>()) {
    getIt.registerSingleton<NetworkConnectivity>(NetworkConnectivity());
  }


  ///order
  if (!getIt.isRegistered<OrderRemoteDatasource>()) {
    getIt.registerLazySingleton<OrderRemoteDatasource>(() =>
        OrderRemoteDatasourceImpl(getIt()));
  }
  if (!getIt.isRegistered<BusinessRemoteDataSource>()) {
    getIt.registerLazySingleton<BusinessRemoteDataSource>(() =>
        BusinessRemoteDataSourceImpl(getIt()));
  }
  if (!getIt.isRegistered<BusinessInfoProviderRepo>()) {
    getIt.registerLazySingleton<BusinessInfoProviderRepo>(() =>
        BusinessInfoProviderRepoImpl(getIt(), getIt()));
  }
  if (!getIt.isRegistered<BusinessInformationProvider>()) {
    getIt.registerLazySingleton(() => BusinessInformationProvider(getIt()));
  }
  if (!getIt.isRegistered<OrderRepository>()) {
    getIt.registerLazySingleton<OrderRepository>(() =>
        OrderRepositoryImpl(getIt(), getIt(), getIt()));
  }

  ///printer
  if (!getIt.isRegistered<BluetoothPrinterHandler>()) {
    getIt.registerLazySingleton(() => BluetoothPrinterHandler());
  }
  if (!getIt.isRegistered<UsbPrinterHandler>()) {
    getIt.registerLazySingleton(() => UsbPrinterHandler());
  }
  if (!getIt.isRegistered<PrinterManager>()) {
    getIt.registerLazySingleton(() =>
        PrinterManager(getIt.get(), getIt.get()));
  }
  if (!getIt.isRegistered<PrinterSettingRepository>()) {
    getIt.registerLazySingleton<PrinterSettingRepository>(() =>
        PrinterSettingRepositoryImpl(getIt.get(), getIt.get()));
  }
  if (!getIt.isRegistered<PrinterSettingCubit>()) {
    getIt.registerFactory(() => PrinterSettingCubit(getIt.get()));
  }
  if (!getIt.isRegistered<UpdatePrinterSettingCubit>()) {
    getIt.registerFactory(() => UpdatePrinterSettingCubit(getIt.get()));
  }

}
