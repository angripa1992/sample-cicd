import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/base/chnage_language_cubit.dart';
import 'package:klikit/modules/base/update_available_view.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/orders/presentation/bloc/cancelled_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/completed_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/new_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/ongoing_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/order_action_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/orders_screen.dart';
import 'package:klikit/notification/inapp/in_app_notification_handler.dart';
import 'package:klikit/notification/notification_data.dart';
import 'package:klikit/notification/notification_data_handler.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/printing_handler.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/segments/event_manager.dart';
import 'package:klikit/segments/segemnt_data_provider.dart';

import '../../app/constants.dart';
import '../../core/utils/response_state.dart';
import '../../language/language_manager.dart';
import '../../resources/strings.dart';
import '../busy/presentation/bloc/fetch_pause_store_data_cubit.dart';
import '../home/presentation/cubit/fetch_zreport_cubit.dart';
import '../home/presentation/home_screen.dart';
import '../menu/presentation/pages/menu_management_screen.dart';
import '../orders/presentation/bloc/all_order_cubit.dart';
import '../orders/presentation/bloc/schedule_order_cubit.dart';
import '../user/presentation/account/account_screen.dart';
import 'fab_bottom_appbar.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final _appPreferences = getIt.get<AppPreferences>();
  final _printingHandler = getIt.get<PrintingHandler>();
  final _languageManager = getIt.get<LanguageManager>();
  final _businessInfoProvider = getIt.get<BusinessInformationProvider>();

  @override
  void initState() {
    context.read<PrinterSettingCubit>().getPrinterSetting();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted) {
          _handleArgumentData();
        }
      },
    );
    super.initState();
  }

  void _handleArgumentData() {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args.containsKey(ArgumentKey.kIS_NOTIFICATION)) {
        if (args[ArgumentKey.kIS_NOTIFICATION]) {
          final navData = NotificationDataHandler().getNavData(args[ArgumentKey.kNOTIFICATION_DATA]);
          context.read<BaseScreenCubit>().changeIndex(navData);
        }
      } else if (args.containsKey(ArgumentKey.kIS_NAVIGATE)) {
        if (args[ArgumentKey.kIS_NAVIGATE]) {
          NavigationData navigationData = args[ArgumentKey.kNAVIGATE_DATA];
          context.read<BaseScreenCubit>().changeIndex(navigationData);
        }
      }
    }
  }

  void _handlePrinterSetting(PrinterSetting setting) async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    await _appPreferences.savePrinterSettings(printerSetting: setting);
    if (args == null) {
      _printingHandler.showDevices(initialIndex: PrinterSelectIndex.docket);
    } else if (args.containsKey(ArgumentKey.kIS_NOTIFICATION)) {
      if (args[ArgumentKey.kIS_NOTIFICATION]) {
        if (args[ArgumentKey.kNOTIFICATION_TYPE] == NotificationType.IN_APP) {
          return;
        }
        final NotificationData notificationData = args[ArgumentKey.kNOTIFICATION_DATA];
        final order = await NotificationDataHandler().getOrderById(notificationData.orderId.toInt());
        if (order != null && order.status == OrderStatus.ACCEPTED) {
          _printingHandler.printDocket(order: order, isAutoPrint: true);
        }
      }
    }
  }

  Widget _getWidget(NavigationData navigationData) {
    if (navigationData.index == BottomNavItem.HOME) {
      return const HomeScreen();
    } else if (navigationData.index == BottomNavItem.ORDER) {
      InAppNotificationHandler().clearOrderBadgeListener();
      return OrdersScreen(
        tabIndex: (navigationData.subTabIndex ?? OrderTab.NEW),
        data: navigationData.data,
      );
    } else if (navigationData.index == BottomNavItem.MENU) {
      return const MenuManagementScreen();
    } else {
      return const AccountScreen();
    }
  }

  void _goToAddOrderScreen() {
    Navigator.of(context).pushNamed(Routes.addOrder);
  }

  void trackEvents(int index) async {
    String eventName = '';
    switch (index) {
      case 1:
        eventName = SegmentEvents.MODULE_CLICK_ORDER_DASHBOARD;
        break;
      case 2:
        eventName = SegmentEvents.MODULE_CLICK_ADD_ORDER;
        break;
      case 3:
        eventName = SessionManager().menuV2Enabled() ? SegmentEvents.MODULE_CLICK_MENU_V2 : SegmentEvents.MODULE_CLICK_MENU_V1;
        break;
      default:
        break;
    }

    if (eventName.isNotEmpty) {
      final brandIds = await _businessInfoProvider.findBrandsIds();
      SegmentManager().track(
        event: eventName,
        properties: {
          'brand_ids': brandIds.toString(),
          'branch_ids': SessionManager().branchIDs().toString(),
          'business_id': SessionManager().businessID(),
        },
      );
    }
  }

  void _selectedTab(int index) {
    trackEvents(index);
    if (index == BottomNavItem.ADD_ORDER) {
      _goToAddOrderScreen();
    } else {
      context.read<BaseScreenCubit>().changeIndex(NavigationData(index: index, subTabIndex: null, data: null));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchPauseStoreDataCubit>(create: (_) => getIt.get()),
        BlocProvider<TotalOrderCubit>(create: (_) => getIt.get<TotalOrderCubit>()),
        BlocProvider<YesterdayTotalOrderCubit>(create: (_) => getIt.get<YesterdayTotalOrderCubit>()),
        BlocProvider<CompletedOrderCubit>(create: (_) => getIt.get<CompletedOrderCubit>()),
        BlocProvider<CancelledOrderCubit>(create: (_) => getIt.get<CancelledOrderCubit>()),
        BlocProvider<NewOrderCubit>(create: (_) => getIt.get<NewOrderCubit>()),
        BlocProvider<AllOrderCubit>(create: (_) => getIt.get<AllOrderCubit>()),
        BlocProvider<ScheduleOrderCubit>(create: (_) => getIt.get<ScheduleOrderCubit>()),
        BlocProvider<OngoingOrderCubit>(create: (_) => getIt.get<OngoingOrderCubit>()),
        BlocProvider<OrderActionCubit>(create: (_) => getIt.get<OrderActionCubit>()),
        BlocProvider<FetchZReportCubit>(create: (_) => getIt.get<FetchZReportCubit>()),
      ],
      child: WillPopScope(
        onWillPop: () {
          if (context.read<BaseScreenCubit>().state.index == BottomNavItem.HOME) {
            return Future.value(true);
          } else {
            _selectedTab(BottomNavItem.HOME);
            return Future.value(false);
          }
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<PrinterSettingCubit, ResponseState>(
              listener: (context, state) {
                if (state is Success<PrinterSetting>) {
                  _handlePrinterSetting(state.data);
                }
              },
            ),
            BlocListener<ChangeLanguageCubit, ChangeLanguageState>(
              listener: (_, state) {
                if (state is OnChangeState) {
                  _languageManager.changeLocale(
                    context: context,
                    locale: state.locale,
                    languageId: state.id,
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<BaseScreenCubit, NavigationData>(
            builder: (context, data) {
              return Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _getWidget(data),
                    ),
                    const UpdateAvailableView(),
                  ],
                ),
                bottomNavigationBar: FABBottomAppBar(
                  initialIndex: data.index,
                  centerItemText: AppStrings.add_order.tr(),
                  color: AppColors.greyDarker,
                  selectedColor: Colors.deepPurpleAccent,
                  notchedShape: const CircularNotchedRectangle(),
                  onTabSelected: _selectedTab,
                  items: [
                    FABBottomAppBarItem(
                      iconData: Icons.home_outlined,
                      text: AppStrings.home.tr(),
                      index: BottomNavItem.HOME,
                    ),
                    FABBottomAppBarItem(
                      iconData: Icons.list_alt,
                      text: AppStrings.orders.tr(),
                      index: BottomNavItem.ORDER,
                    ),
                    FABBottomAppBarItem(
                      iconData: Icons.add_circle_outline_sharp,
                      text: AppStrings.add_order.tr(),
                      index: BottomNavItem.ADD_ORDER,
                    ),
                    FABBottomAppBarItem(
                      iconData: Icons.dashboard,
                      text: AppStrings.menu.tr(),
                      index: BottomNavItem.MENU,
                    ),
                    FABBottomAppBarItem(
                      iconData: Icons.account_circle_outlined,
                      text: AppStrings.account.tr(),
                      index: BottomNavItem.ACCOUNT,
                    ),
                  ],
                  backgroundColor: Colors.white,
                ),
                // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                // floatingActionButton: FloatingActionButton(
                //   onPressed: _goToAddOrderScreen,
                //   tooltip: AppStrings.add_order.tr(),
                //   elevation: 2.0,
                //   foregroundColor: Colors.grey,
                //   backgroundColor: Colors.white,
                //   child: const Icon(Icons.add),
                // ),
              );
            },
          ),
        ),
      ),
    );
  }
}
