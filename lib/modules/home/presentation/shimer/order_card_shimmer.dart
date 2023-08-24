import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../resources/fonts.dart';
import '../../../../../resources/values.dart';
import '../../../widgets/shimmer/container_shimmer.dart';

class OrdersCardShimmer extends StatelessWidget {
  final String text;
  final double fontSize;
  final double orderTextHeight;

  const OrdersCardShimmer({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.orderTextHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.greyDarker,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s18.rw,
          vertical: AppSize.s18.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContainerShimmer(
              baseColor: AppColors.greyLight,
              highlightColor: AppColors.grey,
              height: AppFontSize.s14.rh,
              width: AppSize.s32.rw,
            ),
            SizedBox(height: AppSize.s4.rh),
            Shimmer.fromColors(
              baseColor: AppColors.black,
              highlightColor: AppColors.grey,
              enabled: true,
              child: Text(
                text,
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: fontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
