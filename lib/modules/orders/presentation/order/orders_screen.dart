import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_header.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../../resources/strings.dart';
import '../../../../resources/styles.dart';
import '../components/busy_mode_view.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
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
            const SliverToBoxAdapter(
              child: OrderHeaderView(),
            ),
            SliverPersistentHeader(
              delegate: MyDelegate(
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'New',),
                    Tab(text: 'Ongoing',),
                    Tab(text: 'Order History',),
                  ],
                  unselectedLabelColor: AppColors.lightViolet,
                  labelColor: AppColors.white,
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

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenSizes.statusBarHeight,
        right: AppSize.s18.rw,
        left: AppSize.s18.rw,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s4.rSp),
        color: AppColors.lightVioletTwo,
      ),
      child: tabBar,
    );
  }

  @override
  double get maxExtent =>
      tabBar.preferredSize.height + ScreenSizes.statusBarHeight;

  @override
  double get minExtent =>
      tabBar.preferredSize.height + ScreenSizes.statusBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
