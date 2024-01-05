import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/device_information_provider.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/home_filter_screen.dart';
import 'package:klikit/modules/home/presentation/shimer/home_order_nav_card_shimmer.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../core/route/routes.dart';
import '../../../core/widgets/filter/filter_data.dart';
import '../../../segments/event_manager.dart';
import '../../../segments/segemnt_data_provider.dart';
import '../../base/base_screen_cubit.dart';
import '../../busy/presentation/pause_store_header_view.dart';
import '../../orders/presentation/bloc/cancelled_order_cubit.dart';
import '../../orders/presentation/bloc/completed_order_cubit.dart';
import '../../orders/presentation/bloc/new_order_cubit.dart';
import '../../orders/presentation/bloc/ongoing_order_cubit.dart';
import '../../orders/presentation/bloc/total_order_cubit.dart';
import '../../orders/presentation/bloc/yesterday_total_order_cubit.dart';
import 'components/home_header_view.dart';
import 'components/home_order_nav_card.dart';
import 'components/order_summary_view.dart';
import 'components/z_report.dart';

// context.read<BaseScreenCubit>().changeIndex(
// NavigationData(
// index: BottomNavItem.ORDER,
// subTabIndex: OrderTab.History,
// data: {
// HistoryNavData.HISTORY_NAV_DATA: HistoryNavData.yesterday(),
// },
// ),
// );

// context.read<BaseScreenCubit>().changeIndex(
// NavigationData(
// index: BottomNavItem.ORDER,
// subTabIndex: OrderTab.History,
// data: {
// HistoryNavData.HISTORY_NAV_DATA: HistoryNavData.today(),
// },
// ),
// );

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    getIt.get<DeviceInfoProvider>().getOsVersion();
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
    context.read<NewOrderCubit>().fetchNewOrder(willShowLoading: isInitialCall);
    context.read<OngoingOrderCubit>().fetchOngoingOrder(willShowLoading: isInitialCall);
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeaderView(
                onCartTap: () {
                  Navigator.of(context).pushNamed(Routes.addOrder);
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rw),
                child: OrderSummaryView(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s20.rw,
                  vertical: AppSize.s16.rh,
                ),
                child: const PauseStoreHeaderView(),
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
                        bgColor: AppColors.primary,
                        text: AppStrings.new_orders.tr(),
                        textBaseColor: AppColors.white,
                        textHighlightColor: AppColors.primaryLight,
                        containerBaseColor: AppColors.primaryLight,
                        containerHighlightColor: AppColors.grey,
                      );
                    }
                    return HomeOrderNavCard(
                      numberOfOrders: (state is Success<Orders>) ? state.data.total.toString() : "0",
                      bgColor: AppColors.primary,
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
                        textBaseColor: AppColors.primaryLight,
                        textHighlightColor: AppColors.grey,
                        containerBaseColor: AppColors.primaryLight,
                        containerHighlightColor: AppColors.grey,
                      );
                    }
                    return HomeOrderNavCard(
                      numberOfOrders: (state is Success<Orders>) ? state.data.total.toString() : "0",
                      bgColor: AppColors.white,
                      textColor: AppColors.black,
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
              const ZReportView(),
            ],
          ),
        ),
      ),
    );
  }
}
