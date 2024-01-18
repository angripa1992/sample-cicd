import 'package:badges/badges.dart' as bg;
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';

import '../../../resources/resource_resolver.dart';

class FilterIconView extends StatelessWidget {
  final bool applied;
  final VoidCallback openFilterScreen;

  const FilterIconView({
    super.key,
    required this.applied,
    required this.openFilterScreen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openFilterScreen,
      child: applied
          ? bg.Badge(
        position: bg.BadgePosition.topEnd(end: 0, top: 0),
        badgeStyle: bg.BadgeStyle(
          shape: bg.BadgeShape.circle,
          badgeColor: AppColors.primary,
          padding: EdgeInsets.all(5.rSp),
          borderRadius: BorderRadius.circular(16.rSp),
        ),
        child: _iconButton(),
      )
          : _iconButton(),
    );
  }

  Widget _iconButton() => Container(
    padding: EdgeInsets.all(8.rSp),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24.rSp),
      color: AppColors.grey,
    ),
    child: ImageResourceResolver.filterSVG.getImageWidget(
      width: 20.rSp,
      height: 20.rSp,
      color: applied ? AppColors.primary : AppColors.black,
    ),
  );
}
