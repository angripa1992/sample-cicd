import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/update_busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/cancelled_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/completed_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/new_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/ongoing_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/order_action_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/order/orders_screen.dart';
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
import '../../core/provider/order_information_provider.dart';
import '../../core/utils/response_state.dart';
import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../home/home_screen.dart';
import '../menu/presentation/pages/stock_screen.dart';
import '../user/presentation/account/account_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final _appPreferences = getIt.get<AppPreferences>();
  final _orderInfoProvider = getIt.get<OrderInformationProvider>();
  final _printingHandler = getIt.get<PrintingHandler>();

  @override
  void initState() {
    _orderInfoProvider.loadAllInformation();
    context.read<PrinterSettingCubit>().getPrinterSetting();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>?;
          if (args != null) {
            if (args[ArgumentKey.kIS_NOTIFICATION]) {
              final navData = NotificationDataHandler()
                  .getNavData(args[ArgumentKey.kNOTIFICATION_DATA]);
              context.read<BaseScreenCubit>().changeIndex(navData);
            }
          }
        }
      },
    );
    super.initState();
  }

  void _handlePrinterSetting(PrinterSetting setting) async {
    if (setting.typeId > 0) {
      _appPreferences.savePrinterConnectionType(setting.typeId);
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null && args[ArgumentKey.kIS_NOTIFICATION]) {
        if (args[ArgumentKey.kNOTIFICATION_TYPE] == NotificationType.IN_APP) {
          return;
        }
        final NotificationData notificationData =
            args[ArgumentKey.kNOTIFICATION_DATA];
        final order = await NotificationDataHandler()
            .getOrderById(notificationData.orderId.toInt());
        if (order != null && order.status == OrderStatus.ACCEPTED) {
          _printingHandler.verifyConnection(order: order);
        } else {
          _printingHandler.verifyConnection();
        }
      } else {
        _printingHandler.verifyConnection();
      }
    } else {
      Navigator.pushNamed(context, Routes.printerSettings);
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
    } else if (navigationData.index == BottomNavItem.STOCK) {
      return const StockScreen();
    } else {
      return const AccountScreen();
    }
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
          child: BlocListener<PrinterSettingCubit, ResponseState>(
            listener: (context, state) {
              if (state is Success<PrinterSetting>) {
                _handlePrinterSetting(state.data);
              }
            },
            child: BlocBuilder<BaseScreenCubit, NavigationData>(
              builder: (context, data) {
                return Scaffold(
                  body: Center(child: _getWidget(data)),
                  bottomNavigationBar: BottomNavigationBar(
                    items: _navigationItems(),
                    currentIndex: context.read<BaseScreenCubit>().state.index,
                    onTap: (index) {
                      context.read<BaseScreenCubit>().changeIndex(
                          NavigationData(index: index, subTabIndex: null, data: null));
                    },
                    backgroundColor: AppColors.whiteSmoke,
                    type: BottomNavigationBarType.fixed,
                    selectedItemColor: AppColors.purpleBlue,
                    unselectedItemColor: AppColors.smokeyGrey,
                    selectedLabelStyle: getRegularTextStyle(
                      color: AppColors.purpleBlue,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                    unselectedLabelStyle: getRegularTextStyle(
                      color: AppColors.smokeyGrey,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                );
              },
            ),
          )),
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
