import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../resources/values.dart';

class OrderSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String tooltipMessage;
  final int changeInPercentage;
  final String labelToCompareWith;
  final bool isPositive;
  final Function()? onSummaryClick;

  const OrderSummaryCard({
    Key? key,
    required this.label,
    required this.value,
    required this.tooltipMessage,
    required this.changeInPercentage,
    required this.labelToCompareWith,
    required this.isPositive,
    this.onSummaryClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  label,
                  style: regularTextStyle(),
                ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
                Tooltip(
                  message: tooltipMessage,
                  child: ImageResourceResolver.infoSVG.getImageWidget(
                    width: AppSize.s16.rw,
                    height: AppSize.s16.rh,
                  ),
                ),
              ],
            ),
            AppSize.s4.verticalSpacer(),
            Text(
              value,
              style: boldTextStyle(fontSize: AppSize.s20.rSp, color: AppColors.neutralB700),
            ),
            /*AppSize.s4.verticalSpacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isPositive
                    ? ImageResourceResolver.incrementSVG.getImageWidget(
                        width: AppSize.s12.rw,
                        height: AppSize.s12.rh,
                      )
                    : ImageResourceResolver.decrementSVG.getImageWidget(
                        width: AppSize.s12.rw,
                        height: AppSize.s12.rh,
                      ),
                AppSize.s4.horizontalSpacer(),
                Text(
                  '$changeInPercentage%',
                  style: mediumTextStyle(fontSize: AppSize.s10.rSp, color: isPositive ? AppColors.successG300 : AppColors.errorR300),
                ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s4),
                Text(
                  'vs $labelToCompareWith',
                  style: regularTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.neutralB90),
                )
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
