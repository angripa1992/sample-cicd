import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class RiderInfoView extends StatelessWidget {
  final Order order;

  const RiderInfoView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: order.isThreePlOrder && order.fulfillmentRider != null,
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
              AppStrings.rider_info.tr(),
              style: boldTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            SizedBox(height: AppSize.s4.rh),
            Wrap(
              spacing: 16.0.rw,
              runSpacing: 8.0.rh,
              children: [
                if ((order.fulfillmentRider?.name ?? EMPTY).isNotEmpty)
                  _infoItem(
                    AppStrings.name.tr(),
                    order.fulfillmentRider!.name!,
                  ),
                if ((order.fulfillmentRider?.phone ?? EMPTY).isNotEmpty)
                  _infoItem(
                    AppStrings.contact.tr(),
                    order.fulfillmentRider!.phone!,
                  ),
                if ((order.fulfillmentRider?.licensePlate ?? EMPTY).isNotEmpty)
                  _infoItem(
                    AppStrings.vehicle_registration.tr(),
                    order.fulfillmentRider!.licensePlate!,
                  ),
                if (order.fulfillmentExpectedPickupTime.isNotEmpty)
                  _infoItem(
                    AppStrings.estimated_pickup_time.tr(),
                    DateTimeFormatter.parseOrderCreatedDate(order.fulfillmentExpectedPickupTime),
                  ),
              ],
            ),
          ],
        ),
      ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s8),
    );
  }

  Widget _infoItem(String title, String description) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        Text(
          title,
          style: mediumTextStyle(
            color: AppColors.neutralB300,
            fontSize: AppFontSize.s12.rSp,
          ),
        ),
        SizedBox(height: 2.rh),
        SizedBox(
          width: ScreenSizes.screenWidth/3,
          child: Text(
            description,
            style: regularTextStyle(
              color: AppColors.neutralB500,
              fontSize: AppFontSize.s12.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
