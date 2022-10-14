import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/shimmer/order_item_shimmer.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:shimmer/shimmer.dart';

Widget getNewPageProgressIndicator() {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
      child: Text(
        'Loading...',
        style: getMediumTextStyle(color: AppColors.purpleBlue),
      ),
    ),
  );
}

final shimmers = ['1', '2', '3', '4','5','6','7','8','9','10'];

Widget getFirstPageProgressIndicator() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Column(
        children: shimmers
            .map(
              (e) => const OrderItemShimmer(),
            )
            .toList()),
  );
}

Widget getPageErrorIndicator(VoidCallback onRetry) {
  return Center(
    child: Column(
      children: [
        Text(
          'Something Went Wrong',
          style: getMediumTextStyle(
            color: AppColors.blackCow,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(
          height: AppSize.s8.rh,
        ),
        ElevatedButton(
          onPressed: onRetry,
          style: ElevatedButton.styleFrom(
            primary: AppColors.purpleBlue, // background
            onPrimary: AppColors.white, // foreground
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Try Again'),
              Icon(Icons.refresh),
            ],
          ),
        )
      ],
    ),
  );
}
