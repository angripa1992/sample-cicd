import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/base/base_screen_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/today_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/order/orders_screen.dart';
import 'package:klikit/modules/stock/presentation/pages/stock_screen.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../resources/colors.dart';
import '../../resources/strings.dart';
import '../orders/presentation/home/home_screen.dart';
import '../user/presentation/account/account_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    OrdersScreen(),
    StockScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BusyModeCubit>(create: (_) => getIt.get<BusyModeCubit>()),
        BlocProvider<TodayTotalOrderCubit>(create: (_) => getIt.get<TodayTotalOrderCubit>()),
        BlocProvider<YesterdayTotalOrderCubit>(create: (_) => getIt.get<YesterdayTotalOrderCubit>()),
      ],
      child: WillPopScope(onWillPop: () {
        if (context.read<BaseScreenCubit>().state == 0) {
          return Future.value(true);
        } else {
          context.read<BaseScreenCubit>().changeIndex(0);
          return Future.value(false);
        }
      }, child: BlocBuilder<BaseScreenCubit, int>(
        builder: (context, index) {
          return Scaffold(
            body: Center(child: _widgetOptions.elementAt(index)),
            bottomNavigationBar: BottomNavigationBar(
              items: _navigationItems(),
              currentIndex: context.read<BaseScreenCubit>().state,
              onTap: (index) {
                context.read<BaseScreenCubit>().changeIndex(index);
              },
              backgroundColor: AppColors.whiteSmoke,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.purpleBlue,
              unselectedItemColor: AppColors.smokeyGrey,
              selectedLabelStyle: getRegularTextStyle(
                color: AppColors.purpleBlue,
                fontSize: 14.rSp,
              ),
              unselectedLabelStyle: getRegularTextStyle(
                color: AppColors.smokeyGrey,
                fontSize: 14.rSp,
              ),
            ),
          );
        },
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
        label: AppStrings.stock.tr(),
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
