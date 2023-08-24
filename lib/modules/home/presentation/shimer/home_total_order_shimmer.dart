import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/widgets/shimmer/text_shimmer.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../widgets/shimmer/container_shimmer.dart';

Widget totalOrderShimmer(String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextShimmer(
        baseColor: AppColors.black,
        highlightColor: AppColors.grey,
        text: text,
        textStyle: regularTextStyle(
          color: AppColors.black,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      SizedBox(
        height: AppSize.s8.rh,
      ),
      ContainerShimmer(
        baseColor: AppColors.greyLight,
        highlightColor: AppColors.grey,
        height: AppFontSize.s14.rh,
        width: AppSize.s32.rw,
      ),
    ],
  );
}

Widget yesterdayTotalOrderShimmer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      TextShimmer(
        baseColor: AppColors.greyDarker,
        highlightColor: AppColors.grey,
        text: AppStrings.yesterday.tr(),
        textStyle: regularTextStyle(
          color: AppColors.greyDarker,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      SizedBox(
        height: AppSize.s8.rh,
      ),
      ContainerShimmer(
        baseColor: AppColors.greyLight,
        highlightColor: AppColors.grey,
        height: AppFontSize.s14.rh,
        width: AppSize.s32.rw,
      ),
    ],
  );
}
