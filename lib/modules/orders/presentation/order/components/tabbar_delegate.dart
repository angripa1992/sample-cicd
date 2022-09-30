import 'package:flutter/material.dart';

import '../../../../../app/size_config.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenSizes.statusBarHeight,
        right: AppSize.s12.rw,
        left: AppSize.s12.rw,
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