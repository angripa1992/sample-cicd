import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/today_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/yesterday_total_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/components/busy_mode_view.dart';
import 'package:klikit/modules/orders/presentation/home/components/home_header_view.dart';
import 'package:klikit/modules/orders/presentation/home/components/home_order_nav_card.dart';
import 'package:klikit/modules/orders/presentation/home/components/home_total_order_card.dart';
import 'package:klikit/modules/orders/presentation/components/orders_card.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../app/app_preferences.dart';
import '../../../base/base_screen_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  final _user = getIt.get<AppPreferences>().getUser();

  @override
  void initState() {
    _fetchOrder();
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: AppConstant.refreshTime), (timer) {
      _fetchOrder();
    });
  }

  void _fetchOrder(){
    context.read<TodayTotalOrderCubit>().fetchTotalOrder();
    context.read<YesterdayTotalOrderCubit>().fetchTotalOrder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
            width: ScreenSizes.screenWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    HomeHeaderView(
                      userInfo: _user.userInfo,
                    ),
                    Positioned(
                      bottom: -55.rh,
                      left: AppSize.s20.rw,
                      right: AppSize.s20.rw,
                      child: HomeTotalOrdersCard(
                        onTap: () {},
                      ),
                    )
                  ],
                ),
                SizedBox(height: AppSize.s70.rh),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s20.rw,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OrdersCard(
                          text: AppStrings.completed_orders.tr(),
                          orders: '139',
                          orderColor: AppColors.purpleBlue,
                          fontSize: AppFontSize.s14.rSp,
                          orderFontSize: AppFontSize.s24.rSp,
                        ),
                      ),
                      Expanded(
                        child: OrdersCard(
                          text: AppStrings.cancelled_orders.tr(),
                          orders: '15',
                          orderColor: AppColors.red,
                          fontSize: AppFontSize.s14.rSp,
                          orderFontSize: AppFontSize.s24.rSp,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s20.rw,
                    vertical: AppSize.s8.rh,
                  ),
                  child: const BusyModeView(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s20.rw,
                  ),
                  child: HomeOrderNavCard(
                    numberOfOrders: '7',
                    bgColor: AppColors.purpleBlue,
                    textColor: AppColors.white,
                    onTap: () {},
                    text: AppStrings.new_orders.tr(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s20.rw,
                    vertical: AppSize.s10.rh,
                  ),
                  child: HomeOrderNavCard(
                    numberOfOrders: '15',
                    bgColor: AppColors.white,
                    textColor: AppColors.blueViolet,
                    onTap: () {
                      context.read<BaseScreenCubit>().changeIndex(1);
                    },
                    text: AppStrings.ongoing_orders.tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
