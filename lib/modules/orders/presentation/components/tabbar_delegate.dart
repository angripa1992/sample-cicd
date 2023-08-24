import 'package:flutter/material.dart';

import '../../../../../app/size_config.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Align(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s4.rSp),
          color: AppColors.greyLight,
        ),
        child: tabBar,
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height.rh;

  @override
  double get minExtent => tabBar.preferredSize.height.rh;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
