import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/filter/filtered_data_mapper.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/components/schedule_order_screen.dart';
import 'package:klikit/modules/orders/utils/klikit_order_resolver.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
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
import 'oni_filter_manager.dart';
import 'order_screen_navigate_data.dart';

class OrdersScreen extends StatefulWidget {
  final int tabIndex;
  final Map<String, dynamic>? data;

  const OrdersScreen({
    Key? key,
    required this.tabIndex,
    required this.data,
  }) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin, FilterObserver {
  final _filterManager = OniFilterManager();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    OrderScreenNavigateDataHandler().setData(widget.data);
    _tabController!.index = widget.tabIndex;
    _filterManager.addObserver(this, ObserverTag.ORDER_SCREEN);
    SegmentManager().screen(event: SegmentEvents.ORDER_TAB, name: 'Order Tab');
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(AppStrings.order_dashboard.tr()),
        centerTitle: true,
      ),
      body: FutureBuilder<OniFilteredData>(
        future: FilteredDataMapper().initialOniFilteredData(),
        builder: (_, snap) {
          if (snap.hasData && snap.data != null) {
            _filterManager.setFilterData(snap.data);
            KlikitOrderResolver().refreshOrderCounts(context, filteredData: snap.data);
            return _body();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _body() {
    return NestedScrollView(
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, isScrolled) {
        return [
          SliverToBoxAdapter(
            child: OrderHeaderView(oniFilterManager: _filterManager, tabController: _tabController!),
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
                        count: state is Success<Orders> ? state.data.total : 0,
                      );
                    },
                  ),
                  BlocBuilder<OngoingOrderCubit, ResponseState>(
                    builder: (context, state) {
                      return OrderTabItem(
                        title: AppStrings.ready.tr(),
                        count: state is Success<Orders> ? state.data.total : 0,
                      );
                    },
                  ),
                  BlocBuilder<AllOrderCubit, ResponseState>(
                    builder: (context, state) {
                      return OrderTabItem(
                        title: AppStrings.all.tr(),
                        count: state is Success<Orders> ? state.data.total : 0,
                      );
                    },
                  ),
                  BlocBuilder<ScheduleOrderCubit, ResponseState>(
                    builder: (context, state) {
                      return OrderTabItem(
                        title: AppStrings.schedule.tr(),
                        count: state is Success<Orders> ? state.data.total : 0,
                      );
                    },
                  ),
                  OrderTabItem(title: AppStrings.history.tr(), count: 0),
                  OrderTabItem(title: AppStrings.other.tr(), count: 0),
                ],
                labelPadding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 10.rw),
                unselectedLabelColor: AppColors.black,
                labelColor: AppColors.primary,
                indicatorColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontSize: 14.rSp,
                  fontFamily: AppFonts.Inter,
                  fontWeight: AppFontWeight.medium,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.rSp,
                  fontFamily: AppFonts.Inter,
                  fontWeight: AppFontWeight.medium,
                ),
                isScrollable: true,
              ),
            ),
            pinned: true,
            floating: true,
          ),
        ];
      },
      body: Container(
        padding: EdgeInsets.only(left: 12.rw, right: 12.rw, top: 12.rh),
        color: AppColors.white,
        child: TabBarView(
          controller: _tabController,
          children: [
            NewOrderScreen(oniFilterManager: _filterManager),
            OngoingOrderScreen(oniFilterManager: _filterManager),
            AllOrderScreen(oniFilterManager: _filterManager),
            ScheduleOrderScreen(oniFilterManager: _filterManager),
            OrderHistoryScreen(oniFilterManager: _filterManager),
            OthersOrderScreen(oniFilterManager: _filterManager),
          ],
        ),
      ),
    );
  }

  @override
  void applyFilter(OniFilteredData? filteredData) {
    KlikitOrderResolver().refreshOrderCounts(context, filteredData: filteredData);
  }
}
