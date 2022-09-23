import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../resources/values.dart';

class ContainerShimmer extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;
  final double height;
  final double width;

  const ContainerShimmer({
    Key? key,
    required this.baseColor,
    required this.highlightColor,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      enabled: true,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s5.rSp),
          color: baseColor,
        ),
      ),
    );
  }
}
