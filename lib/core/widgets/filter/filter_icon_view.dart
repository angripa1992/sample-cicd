import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';

import '../../../resources/resource_resolver.dart';

class FilterIconView extends StatelessWidget {
  final bool applied;
  final VoidCallback applyFilter;

  const FilterIconView({
    super.key,
    required this.applied,
    required this.applyFilter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: applyFilter,
      child: Container(
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
      ),
    );
  }
}
