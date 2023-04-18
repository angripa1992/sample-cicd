import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/schedule_order_screen.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';
import 'package:klikit/segments/event_manager.dart';
import 'package:badges/badges.dart' as badges;

import '../../../../app/constants.dart';
import '../../../../resources/styles.dart';
import '../../../../segments/segemnt_data_provider.dart';
import 'bloc/new_order_cubit.dart';
import 'bloc/ongoing_order_cubit.dart';
import 'bloc/schedule_order_cubit.dart';
import 'components/new_order_screen.dart';
import 'components/ongoing_order_screen.dart';
import 'components/order_header.dart';
import 'components/order_history_screen.dart';
import 'components/tabbar_delegate.dart';
import 'filter_observer.dart';
import 'filter_subject.dart';
import 'order_screen_navigate_data.dart';

class OrdersScreen extends StatefulWidget {
  final int tabIndex;
  final Map<String, dynamic>? data;

  const OrdersScreen({Key? key, required this.tabIndex, required this.data})
      : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin, FilterObserver {
  final _filterSubject = FilterSubject();
  TabController? _tabController;
  List<int>? _providers;
  List<int>? _brands;

  final _badgeStyle = BadgeStyle(
    shape: BadgeShape.square,
    badgeColor: AppColors.red,
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.s12.rw,
      vertical: AppSize.s2.rh,
    ),
    borderRadius: BorderRadius.circular(AppSize.s16.rSp),
  );

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    OrderScreenNavigateDataHandler().setData(widget.data);
    _tabController!.index = widget.tabIndex;
    filterSubject = _filterSubject;
    filterSubject?.addObserver(this, ObserverTag.ORDER_SCREEN);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _refreshOrderCount();
    SegmentManager().screen(event: SegmentEvents.ORDER_TAB, name: 'Order Tab');
    super.initState();
  }

  void _refreshOrderCount() {
    context.read<NewOrderCubit>().fetchNewOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
    context.read<OngoingOrderCubit>().fetchOngoingOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
    context.read<ScheduleOrderCubit>().fetchScheduleOrder(
          willShowLoading: false,
          providersID: _providers,
          brandsID: _brands,
        );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.order_dashboard.tr()),
        titleTextStyle: getAppBarTextStyle(),
        flexibleSpace: getAppBarBackground(),
        centerTitle: true,
      ),
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverToBoxAdapter(
              child: OrderHeaderView(
                subject: _filterSubject,
                tabController: _tabController!,
              ),
            ),
            SliverPersistentHeader(
              delegate: MyDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: [
                    BlocBuilder<NewOrderCubit, ResponseState>(
                      builder: (context, state) {
                        if (state is Success<Orders> && state.data.total > 0) {
                          return badges.Badge(
                            position: BadgePosition.topEnd(top: -22, end: -20),
                            badgeContent: Text(
                              '${state.data.total}',
                              style:
                                  getRegularTextStyle(color: AppColors.white),
                            ),
                            badgeStyle: _badgeStyle,
                            child: Text(AppStrings.newOrder.tr()),
                          );
                        }
                        return Text(AppStrings.newOrder.tr());
                      },
                    ),
                    BlocBuilder<OngoingOrderCubit, ResponseState>(
                      builder: (context, state) {
                        if (state is Success<Orders> && state.data.total > 0) {
                          return badges.Badge(
                            position: BadgePosition.topEnd(top: -22, end: -16),
                            badgeContent: Text(
                              '${state.data.total}',
                              style:
                                  getRegularTextStyle(color: AppColors.white),
                            ),
                            badgeStyle: _badgeStyle,
                            child: Text(AppStrings.ready.tr()),
                          );
                        }
                        return Text(AppStrings.ready.tr());
                      },
                    ),
                    BlocBuilder<ScheduleOrderCubit, ResponseState>(
                      builder: (context, state) {
                        if (state is Success<Orders> && state.data.total > 0) {
                          return badges.Badge(
                            position: BadgePosition.topEnd(top: -22, end: -6),
                            badgeContent: Text(
                              '${state.data.total}',
                              style:
                                  getRegularTextStyle(color: AppColors.white),
                            ),
                            badgeStyle: _badgeStyle,
                            child: Text('Schedule'),
                          );
                        }
                        return Text('Schedule');
                      },
                    ),
                    Tab(text: 'History'),
                  ],
                  labelPadding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                  unselectedLabelColor: AppColors.lightViolet,
                  labelColor: AppColors.white,
                  labelStyle: TextStyle(
                    fontSize: AppFontSize.s14.rSp,
                    fontFamily: AppFonts.Aeonik,
                    fontWeight: AppFontWeight.regular,
                  ),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s4.rSp),
                    border: Border.all(color: AppColors.purpleBlue),
                    color: AppColors.purpleBlue,
                  ),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: Container(
          padding: EdgeInsets.only(
            left: AppSize.s12.rw,
            right: AppSize.s12.rw,
            top: AppSize.s12.rh,
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              NewOrderScreen(subject: _filterSubject),
              OngoingOrderScreen(subject: _filterSubject),
              ScheduleOrderScreen(subject: _filterSubject),
              OrderHistoryScreen(subject: _filterSubject),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void applyBrandsFilter(List<int> brandsID) {
    _brands = brandsID;
    _refreshOrderCount();
  }

  @override
  void applyProviderFilter(List<int> providersID) {
    _providers = providersID;
    _refreshOrderCount();
  }

  @override
  void applyStatusFilter(List<int> status) {}
}
