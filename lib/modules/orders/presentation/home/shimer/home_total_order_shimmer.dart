import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/shimmer/text_shimmer.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../widgets/shimmer/container_shimmer.dart';

Widget todayTotalOrderShimmer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextShimmer(
        baseColor: AppColors.blackCow,
        highlightColor: AppColors.whiteSmoke,
        text: AppStrings.total_orders_today.tr(),
        textStyle: getRegularTextStyle(
          color: AppColors.blackCow,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      ContainerShimmer(
        baseColor: AppColors.lightGrey,
        highlightColor: AppColors.whiteSmoke,
        height: AppSize.s16.rh,
        width: AppSize.s100.rw,
      ),
    ],
  );
}

Widget yesterdayTotalOrderShimmer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      TextShimmer(
        baseColor: AppColors.coolGrey,
        highlightColor: AppColors.whiteSmoke,
        text: AppStrings.yesterday.tr(),
        textStyle: getRegularTextStyle(
          color: AppColors.coolGrey,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      ContainerShimmer(
        baseColor: AppColors.lightGrey,
        highlightColor: AppColors.whiteSmoke,
        height: AppSize.s12.rh,
        width: AppSize.s50.rw,
      ),
    ],
  );
}
