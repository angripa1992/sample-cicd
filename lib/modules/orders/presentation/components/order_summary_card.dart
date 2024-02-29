import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_tooltip.dart';
import 'package:klikit/modules/home/domain/entities/order_summary_overview.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../resources/values.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderSummaryOverview overview;
  final String labelToCompareWith;
  final Function()? onSummaryClick;

  const OrderSummaryCard({
    Key? key,
    required this.overview,
    required this.labelToCompareWith,
    this.onSummaryClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = overview.comparisonData.status.toLowerCase();
    return InkWell(
      onTap: onSummaryClick,
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.all(AppSize.s8.rSp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overview.label,
                  style: regularTextStyle(),
                ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
                KTTooltip(
                  message: overview.tooltipMessage,
                  child: ImageResourceResolver.infoSVG.getImageWidget(
                    width: AppSize.s16.rw,
                    height: AppSize.s16.rh,
                  ),
                ),
              ],
            ),
            AppSize.s4.verticalSpacer(),
            Text(
              overview.value,
              style: boldTextStyle(fontSize: AppSize.s20.rSp, color: AppColors.neutralB700),
            ),
            AppSize.s8.verticalSpacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                trendingIcon(status),
                AppSize.s4.horizontalSpacer(),
                Text(
                  '${overview.comparisonData.value}%',
                  style: mediumTextStyle(fontSize: AppSize.s10.rSp, color: trendingColor(status)),
                ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s4),
                Text(
                  '${AppStrings.vs.tr()} $labelToCompareWith',
                  style: regularTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.neutralB90),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget trendingIcon(String status) {
    return status == 'gain'
        ? ImageResourceResolver.incrementSVG.getImageWidget(
            width: AppSize.s12.rw,
            height: AppSize.s12.rh,
          )
        : status == 'lose'
            ? ImageResourceResolver.decrementSVG.getImageWidget(
                width: AppSize.s12.rw,
                height: AppSize.s12.rh,
              )
            : ImageResourceResolver.neutralSVG.getImageWidget(
                width: AppSize.s12.rw,
                height: AppSize.s12.rh,
              );
  }

  Color trendingColor(String status) {
    return status == 'gain'
        ? AppColors.successG300
        : status == 'lose'
            ? AppColors.errorR300
            : AppColors.neutralB100;
  }
}
