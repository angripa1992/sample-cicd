import 'package:flutter/material.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/size_config.dart';
import '../../../../../resources/colors.dart';

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
        padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
        color: AppColors.white,
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
