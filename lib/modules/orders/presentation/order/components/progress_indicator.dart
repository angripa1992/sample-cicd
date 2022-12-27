import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/shimmer/order_item_shimmer.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';
import 'package:shimmer/shimmer.dart';

Widget getNewPageProgressIndicator(BuildContext context) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
      child: Text(
        AppStrings.loading.tr(),
        style: getMediumTextStyle(color: AppColors.purpleBlue),
      ),
    ),
  );
}

final shimmers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

Widget getFirstPageProgressIndicator(BuildContext context) {
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
          AppStrings.defaultError.tr(),
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
            children: [
              Text(AppStrings.try_again.tr()),
              const Icon(Icons.refresh),
            ],
          ),
        )
      ],
    ),
  );
}

Widget noItemsFoundIndicator(BuildContext context) {
  return Center(
    child: Column(
      children: [
        SizedBox(height: AppSize.s50.rh),
        Image.asset(
          AppImages.emptyCart,
          height: AppSize.s65.rh,
          width: AppSize.s65.rw,
        ),
        Text(
          AppStrings.no_orders_found.tr(),
          style: getMediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s18.rSp,
          ),
        ),
      ],
    ),
  );
}
