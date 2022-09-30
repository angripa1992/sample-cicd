import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_header.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_subject.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import 'components/tabbar_delegate.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  final _filterSubject = FilterSubject();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverToBoxAdapter(
              child: OrderHeaderView(subject: _filterSubject),
            ),
            SliverPersistentHeader(
              delegate: MyDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'New'),
                    Tab(text: 'Ongoing'),
                    Tab(text: 'Order History'),
                  ],
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
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
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s18.rw),
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return Text('Value $index');
              },
            ),
          ),
        ),
      ),
    );
  }
}
