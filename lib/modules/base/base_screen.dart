import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/permission_handler.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/base/chnage_language_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/cancelled_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/completed_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/new_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/ongoing_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/order_action_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/update_busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/orders_screen.dart';
import 'package:klikit/notification/notification_data.dart';
import 'package:klikit/notification/notification_data_handler.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/printer_setting_cubit.dart';
import 'package:klikit/printer/printing_handler.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../app/constants.dart';
import '../../core/utils/response_state.dart';
import '../../language/language_manager.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../add_order/presentation/pages/add_order_screen.dart';
import '../home/home_screen.dart';
import '../menu/presentation/pages/stock_screen.dart';
import '../orders/presentation/bloc/all_order_cubit.dart';
import '../orders/presentation/bloc/schedule_order_cubit.dart';
import '../user/presentation/account/account_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final _appPreferences = getIt.get<AppPreferences>();
  final _printingHandler = getIt.get<PrintingHandler>();
  final _languageManager = getIt.get<LanguageManager>();

  @override
  void initState() {
    context.read<PrinterSettingCubit>().getPrinterSetting();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          if (args != null) {
            if (args[ArgumentKey.kIS_NOTIFICATION]) {
              final navData = NotificationDataHandler().getNavData(args[ArgumentKey.kNOTIFICATION_DATA]);
              context.read<BaseScreenCubit>().changeIndex(navData);
            }
          }
        }
      },
    );
    PermissionHandler().requestNotificationPermissions();
    super.initState();
  }

  void _handlePrinterSetting(PrinterSetting setting) async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    await _appPreferences.savePrinterSettings(printerSetting: setting);
    if (args != null && args[ArgumentKey.kIS_NOTIFICATION]) {
      if (args[ArgumentKey.kNOTIFICATION_TYPE] == NotificationType.IN_APP) {
        return;
      }
      final NotificationData notificationData = args[ArgumentKey.kNOTIFICATION_DATA];
      final order = await NotificationDataHandler().getOrderById(notificationData.orderId.toInt());
      if (order != null && order.status == OrderStatus.ACCEPTED) {
        _printingHandler.printDocket(order: order, isAutoPrint: true);
      }
    } else {
      _printingHandler.showDevices(initialIndex: PrinterSelectIndex.docket);
    }
  }

  Widget _getWidget(NavigationData navigationData) {
    if (navigationData.index == BottomNavItem.HOME) {
      return const HomeScreen();
    } else if (navigationData.index == BottomNavItem.ORDER) {
      return OrdersScreen(
        tabIndex: (navigationData.subTabIndex ?? OrderTab.NEW),
        data: navigationData.data,
      );
    } else if (navigationData.index == BottomNavItem.MENU) {
      return const StockScreen();
    }
    // else if (navigationData.index == BottomNavItem.ADD_ORDER) {
    //   return const AddOrderScreen();
    // }
    else {
      return const AccountScreen();
    }
  }

  void _goToAddOrderScreen(NavigationData data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddOrderScreen(
          willOpenCart: false,
          willUpdateCart: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusyModeCubit>(create: (_) => getIt.get<BusyModeCubit>()),
        BlocProvider<UpdateBusyModeCubit>(
            create: (_) => getIt.get<UpdateBusyModeCubit>()),
        BlocProvider<TotalOrderCubit>(
            create: (_) => getIt.get<TotalOrderCubit>()),
        BlocProvider<YesterdayTotalOrderCubit>(
            create: (_) => getIt.get<YesterdayTotalOrderCubit>()),
        BlocProvider<CompletedOrderCubit>(
            create: (_) => getIt.get<CompletedOrderCubit>()),
        BlocProvider<CancelledOrderCubit>(
            create: (_) => getIt.get<CancelledOrderCubit>()),
        BlocProvider<NewOrderCubit>(create: (_) => getIt.get<NewOrderCubit>()),
        BlocProvider<AllOrderCubit>(create: (_) => getIt.get<AllOrderCubit>()),
        BlocProvider<ScheduleOrderCubit>(
            create: (_) => getIt.get<ScheduleOrderCubit>()),
        BlocProvider<OngoingOrderCubit>(
            create: (_) => getIt.get<OngoingOrderCubit>()),
        BlocProvider<OrderActionCubit>(
            create: (_) => getIt.get<OrderActionCubit>()),
      ],
      child: WillPopScope(
        onWillPop: () {
          if (context.read<BaseScreenCubit>().state.index ==
              BottomNavItem.HOME) {
            return Future.value(true);
          } else {
            context.read<BaseScreenCubit>().changeIndex(
                NavigationData(index: BottomNavItem.HOME, data: null));
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
                body: Center(child: _getWidget(data)),
                bottomNavigationBar: BottomNavigationBar(
                  items: _navigationItems(),
                  currentIndex: context.read<BaseScreenCubit>().state.index,
                  onTap: (index) {
                    if (index == BottomNavItem.ADD_ORDER) {
                      _goToAddOrderScreen(data);
                    } else {
                      context.read<BaseScreenCubit>().changeIndex(
                            NavigationData(
                              index: index,
                              subTabIndex: null,
                              data: null,
                            ),
                          );
                    }
                  },
                  backgroundColor: AppColors.whiteSmoke,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: AppColors.purpleBlue,
                  unselectedItemColor: AppColors.smokeyGrey,
                  selectedLabelStyle: regularTextStyle(
                    color: AppColors.purpleBlue,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                  unselectedLabelStyle: regularTextStyle(
                    color: AppColors.smokeyGrey,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _navigationItems() {
    return [
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.home),
        activeIcon: _generateNavIcon(AppIcons.homeActive),
        label: AppStrings.home.tr(),
      ),
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.order),
        activeIcon: _generateNavIcon(AppIcons.orderActive),
        label: AppStrings.orders.tr(),
      ),
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.add),
        activeIcon: _generateNavIcon(AppIcons.addActive),
        label: 'Add Order',
      ),
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.stock),
        activeIcon: _generateNavIcon(AppIcons.stockActive),
        label: AppStrings.menu.tr(),
      ),
      BottomNavigationBarItem(
        icon: _generateNavIcon(AppIcons.account),
        activeIcon: _generateNavIcon(AppIcons.accountActive),
        label: AppStrings.account.tr(),
      ),
    ];
  }

  Widget _generateNavIcon(String iconPath) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.s4),
      child: SizedBox(
        height: AppSize.s20.rh,
        width: AppSize.s20.rw,
        child: SvgPicture.asset(iconPath),
      ),
    );
  }
}
