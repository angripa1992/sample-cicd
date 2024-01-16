import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/base/common_dashboard_app_bar.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/schedule_order_screen.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';
import 'package:klikit/segments/event_manager.dart';

import '../../../../app/constants.dart';
import '../../../../segments/segemnt_data_provider.dart';
import 'bloc/all_order_cubit.dart';
import 'bloc/new_order_cubit.dart';
import 'bloc/ongoing_order_cubit.dart';
import 'bloc/schedule_order_cubit.dart';
import 'components/all_order_screen.dart';
import 'components/new_order_screen.dart';
import 'components/ongoing_order_screen.dart';
import 'components/order_header.dart';
import 'components/order_history_screen.dart';
import 'components/order_tab_item.dart';
import 'components/others_order_screen.dart';
import 'components/tabbar_delegate.dart';
import 'filter_observer.dart';
import 'filter_subject.dart';
import 'order_screen_navigate_data.dart';

class OrdersScreen extends StatefulWidget {
  final int tabIndex;
  final Map<String, dynamic>? data;

  const OrdersScreen({Key? key, required this.tabIndex, required this.data}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin, FilterObserver {
  final _filterSubject = FilterSubject();
  TabController? _tabController;
  ValueNotifier<int>? tabIndexChangeListener;
  List<int>? _providers;
  List<int>? _brands;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    tabIndexChangeListener = ValueNotifier(widget.tabIndex);
    _tabController?.addListener(() {
      tabIndexChangeListener?.value = _tabController?.index ?? widget.tabIndex;
    });
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
    context.read<AllOrderCubit>().fetchAllOrder(
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
    tabIndexChangeListener?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonDashboardAppBar(title: AppStrings.orders.tr()),
          AppSize.s1.verticalSpacer(),
          Expanded(
            child: NestedScrollView(
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
                              return OrderTabItem(
                                title: AppStrings.new_str.tr(),
                                tabIndex: 0,
                                tabIndexChangeListener: tabIndexChangeListener ?? ValueNotifier(widget.tabIndex),
                                count: state is Success<Orders> ? state.data.total : 0,
                              );
                            },
                          ),
                          BlocBuilder<OngoingOrderCubit, ResponseState>(
                            builder: (context, state) {
                              return OrderTabItem(
                                title: AppStrings.ready.tr(),
                                tabIndex: 1,
                                tabIndexChangeListener: tabIndexChangeListener ?? ValueNotifier(widget.tabIndex),
                                count: state is Success<Orders> ? state.data.total : 0,
                              );
                            },
                          ),
                          BlocBuilder<AllOrderCubit, ResponseState>(
                            builder: (context, state) {
                              return OrderTabItem(
                                title: AppStrings.all.tr(),
                                tabIndex: 2,
                                tabIndexChangeListener: tabIndexChangeListener ?? ValueNotifier(widget.tabIndex),
                                count: state is Success<Orders> ? state.data.total : 0,
                              );
                            },
                          ),
                          BlocBuilder<ScheduleOrderCubit, ResponseState>(
                            builder: (context, state) {
                              return OrderTabItem(
                                title: AppStrings.schedule.tr(),
                                tabIndex: 3,
                                tabIndexChangeListener: tabIndexChangeListener ?? ValueNotifier(widget.tabIndex),
                                count: state is Success<Orders> ? state.data.total : 0,
                              );
                            },
                          ),
                          OrderTabItem(
                            title: AppStrings.history.tr(),
                            tabIndex: 4,
                            tabIndexChangeListener: tabIndexChangeListener ?? ValueNotifier(widget.tabIndex),
                            count: 0,
                          ),
                          OrderTabItem(
                            title: AppStrings.other.tr(),
                            tabIndex: 5,
                            tabIndexChangeListener: tabIndexChangeListener ?? ValueNotifier(widget.tabIndex),
                            count: 0,
                          ),
                        ],
                        labelPadding: EdgeInsets.all(AppSize.s8.rSp),
                        indicatorColor: Colors.transparent,
                        indicatorWeight: 0.01,
                        isScrollable: true,
                      ),
                    ),
                    pinned: true,
                    floating: true,
                  ),
                ];
              },
              body: Container(
                padding: EdgeInsets.only(
                  left: AppSize.s12.rw,
                  right: AppSize.s12.rw,
                  top: AppSize.s12.rh,
                ),
                color: AppColors.white,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    NewOrderScreen(subject: _filterSubject),
                    OngoingOrderScreen(subject: _filterSubject),
                    AllOrderScreen(subject: _filterSubject),
                    ScheduleOrderScreen(subject: _filterSubject),
                    OrderHistoryScreen(subject: _filterSubject),
                    OthersOrderScreen(subject: _filterSubject),
                  ],
                ),
              ),
            ),
          ),
        ],
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
