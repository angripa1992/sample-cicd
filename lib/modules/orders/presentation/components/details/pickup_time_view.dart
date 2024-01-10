import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/order.dart';

class PickupTimeView extends StatelessWidget {
  final Order order;

  const PickupTimeView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: order.estimatedPickUpAt.isNotEmpty,
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s16.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.estimated_pickup_time.tr(),
              style: semiBoldTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s17.rSp,
              ),
            ),
            SizedBox(height: AppSize.s4.rh),
            Text(
              DateTimeProvider.parseOrderCreatedDate(order.estimatedPickUpAt),
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ],
        ),
      ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s8.rh),
    );
  }
}
