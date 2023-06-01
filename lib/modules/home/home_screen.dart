import 'dart:async';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/home/shimer/home_order_nav_card_shimmer.dart';
import 'package:klikit/modules/home/shimer/order_card_shimmer.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/busy_mode_view.dart';
import 'package:klikit/modules/orders/presentation/components/orders_card.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../resources/styles.dart';
import '../../app/session_manager.dart';
import '../../segments/event_manager.dart';
import '../../segments/segemnt_data_provider.dart';
import '../add_order/presentation/pages/add_order_screen.dart';
import '../base/base_screen_cubit.dart';
import '../orders/presentation/bloc/cancelled_order_cubit.dart';
import '../orders/presentation/bloc/completed_order_cubit.dart';
import '../orders/presentation/bloc/new_order_cubit.dart';
import '../orders/presentation/bloc/ongoing_order_cubit.dart';
import '../orders/presentation/bloc/total_order_cubit.dart';
import '../orders/presentation/bloc/yesterday_total_order_cubit.dart';
import 'components/home_header_view.dart';
import 'components/home_order_nav_card.dart';
import 'components/home_total_order_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    _fetchOrder(true);
    _startTimer();
    SegmentManager().screen(event: SegmentEvents.HOME_TAB, name: 'Home Tab');
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: AppConstant.refreshTime),
      (timer) {
        _fetchOrder(false);
      },
    );
  }

  void _fetchOrder(bool isInitialCall) {
    context.read<TotalOrderCubit>().fetchTodayTotalOrder(
          willShowLoading: isInitialCall,
        );
    context.read<CompletedOrderCubit>().fetchTodayCompletedOrder(
          willShowLoading: isInitialCall,
        );
    context.read<CancelledOrderCubit>().fetchTodayCancelledOrder(
          willShowLoading: isInitialCall,
        );
    context.read<NewOrderCubit>().fetchNewOrder(
          willShowLoading: isInitialCall,
        );
    context.read<OngoingOrderCubit>().fetchOngoingOrder(
          willShowLoading: isInitialCall,
        );
    if (isInitialCall) {
      context.read<YesterdayTotalOrderCubit>().fetchTotalOrder();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        flexibleSpace: getAppBarBackground(),
      ),
      body: SizedBox(
        height: ScreenSizes.screenHeight - ScreenSizes.statusBarHeight,
        //width: ScreenSizes.screenWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DeferredPointerHandler(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    HomeHeaderView(
                      userInfo: SessionManager().currentUser(),
                      onCartTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddOrderScreen(
                              willOpenCart: true,
                              willUpdateCart: false,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: -50.rh,
                      left: AppSize.s20.rw,
                      right: AppSize.s20.rw,
                      child: DeferPointer(
                        child: HomeTotalOrdersCard(
                          onYesterday: () {
                            context.read<BaseScreenCubit>().changeIndex(
                                  NavigationData(
                                    index: BottomNavItem.ORDER,
                                    subTabIndex: OrderTab.History,
                                    data: {
                                      HistoryNavData.HISTORY_NAV_DATA:
                                          HistoryNavData.yesterday(),
                                    },
                                  ),
                                );
                          },
                          onToday: () {
                            context.read<BaseScreenCubit>().changeIndex(
                                  NavigationData(
                                    index: BottomNavItem.ORDER,
                                    subTabIndex: OrderTab.History,
                                    data: {
                                      HistoryNavData.HISTORY_NAV_DATA:
                                          HistoryNavData.today(),
                                    },
                                  ),
                                );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: AppSize.s90.rh),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s20.rw,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: BlocConsumer<CompletedOrderCubit, ResponseState>(
                          listener: (context, state) {
                            if (state is Failed) {
                              showApiErrorSnackBar(context, state.failure);
                            }
                          },
                          builder: (context, state) {
                            if (state is Loading) {
                              return OrdersCardShimmer(
                                text: AppStrings.completed_orders.tr(),
                                fontSize: AppFontSize.s14.rSp,
                                orderTextHeight: AppFontSize.s24.rSp,
                              );
                            }
                            return OrdersCard(
                              height: AppSize.s90.rh,
                              width: AppSize.s100.rw,
                              text: AppStrings.completed_orders.tr(),
                              orders: (state is Success<Orders>)
                                  ? state.data.total.toString()
                                  : '0',
                              orderColor: AppColors.purpleBlue,
                              fontSize: AppFontSize.s14.rSp,
                              orderFontSize: AppFontSize.s24.rSp,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: AppSize.s8.rw),
                      Expanded(
                        child: BlocConsumer<CancelledOrderCubit, ResponseState>(
                          listener: (context, state) {
                            if (state is Failed) {
                              showApiErrorSnackBar(context, state.failure);
                            }
                          },
                          builder: (context, state) {
                            if (state is Loading) {
                              return OrdersCardShimmer(
                                text: AppStrings.cancelled_orders.tr(),
                                fontSize: AppFontSize.s14.rSp,
                                orderTextHeight: AppFontSize.s24.rSp,
                              );
                            }
                            return OrdersCard(
                              height: AppSize.s90.rh,
                              width: AppSize.s100.rw,
                              text: AppStrings.cancelled_orders.tr(),
                              orders: (state is Success<Orders>)
                                  ? state.data.total.toString()
                                  : '0',
                              orderColor: AppColors.red,
                              fontSize: AppFontSize.s14.rSp,
                              orderFontSize: AppFontSize.s24.rSp,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s20.rw,
                  vertical: AppSize.s16.rh,
                ),
                child: const BusyModeView(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s20.rw,
                ),
                child: BlocConsumer<NewOrderCubit, ResponseState>(
                  listener: (context, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return HomeOrderNavCardShimmer(
                        bgColor: AppColors.purpleBlue,
                        text: AppStrings.new_orders.tr(),
                        textBaseColor: AppColors.white,
                        textHighlightColor: AppColors.lightViolet,
                        containerBaseColor: AppColors.lightViolet,
                        containerHighlightColor: AppColors.whiteSmoke,
                      );
                    }
                    return HomeOrderNavCard(
                      numberOfOrders: (state is Success<Orders>)
                          ? state.data.total.toString()
                          : "0",
                      bgColor: AppColors.purpleBlue,
                      textColor: AppColors.white,
                      onTap: () {
                        context.read<BaseScreenCubit>().changeIndex(
                              NavigationData(
                                index: BottomNavItem.ORDER,
                                subTabIndex: OrderTab.NEW,
                                data: null,
                              ),
                            );
                      },
                      text: AppStrings.new_orders.tr(),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s20.rw,
                  vertical: AppSize.s12.rh,
                ),
                child: BlocConsumer<OngoingOrderCubit, ResponseState>(
                  listener: (context, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return HomeOrderNavCardShimmer(
                        bgColor: AppColors.white,
                        text: AppStrings.ongoing_orders.tr(),
                        textBaseColor: AppColors.blueViolet,
                        textHighlightColor: AppColors.whiteSmoke,
                        containerBaseColor: AppColors.lightViolet,
                        containerHighlightColor: AppColors.whiteSmoke,
                      );
                    }
                    return HomeOrderNavCard(
                      numberOfOrders: (state is Success<Orders>)
                          ? state.data.total.toString()
                          : "0",
                      bgColor: AppColors.white,
                      textColor: AppColors.blueViolet,
                      onTap: () {
                        context.read<BaseScreenCubit>().changeIndex(
                              NavigationData(
                                index: BottomNavItem.ORDER,
                                subTabIndex: OrderTab.ONGOING,
                                data: null,
                              ),
                            );
                      },
                      text: AppStrings.ongoing_orders.tr(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
