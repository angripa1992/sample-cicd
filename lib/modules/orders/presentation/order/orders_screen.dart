import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/new_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/orders/ongoing_order_cubit.dart';
import 'package:klikit/modules/orders/presentation/order/components/new_order_screen.dart';
import 'package:klikit/modules/orders/presentation/order/components/ongoing_order_screen.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_header.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_history_screen.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_observer.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_subject.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../../../app/constants.dart';
import '../../../../resources/styles.dart';
import 'components/tabbar_delegate.dart';
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

  @override
  void initState() {
    print('OrdersScreen===================init');
    _tabController = TabController(length: 3, vsync: this);
    OrderScreenNavigateDataHandler().setData(widget.data);
    _tabController!.index = widget.tabIndex;
    filterSubject = _filterSubject;
    filterSubject?.addObserver(this, ObserverTag.ORDER_SCREEN);
    _providers = filterSubject?.getProviders();
    _brands = filterSubject?.getBrands();
    _refreshOrderCount();
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
        title: const Text('Order Dashboard'),
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
                        return Tab(
                            text: (state is Success<Orders>)
                                ? 'New (${state.data.total})'
                                : 'New');
                      },
                    ),
                    BlocBuilder<OngoingOrderCubit, ResponseState>(
                      builder: (context, state) {
                        return Tab(
                            text: (state is Success<Orders>)
                                ? 'Ready (${state.data.total})'
                                : 'Ready');
                      },
                    ),
                    const Tab(text: 'Order History'),
                  ],
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
                  unselectedLabelColor: AppColors.lightViolet,
                  labelColor: AppColors.white,
                  labelStyle: TextStyle(
                    fontSize: AppFontSize.s12.rSp,
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
