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
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s16.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(),
            Text(
              AppStrings.rider_info.tr(),
              style: boldTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s15.rSp,
              ),
            ),
            SizedBox(height: AppSize.s4.rh),
            Row(
              children: [
                Expanded(
                  child: _infoItem(AppStrings.name.tr(), order.fulfillmentRider?.name ?? EMPTY),
                ),
                Expanded(
                  child: _infoItem(AppStrings.vehicle_registration.tr(), order.fulfillmentRider?.licensePlate ?? EMPTY),
                ),
              ],
            ),
            SizedBox(height: AppSize.s4.rh),
            Row(
              children: [
                Expanded(
                  child: _infoItem(AppStrings.contact.tr(), order.fulfillmentRider?.phone ?? EMPTY),
                ),
                if (order.fulfillmentExpectedPickupTime.isNotEmpty)
                  Expanded(
                    child: _infoItem(
                      AppStrings.estimated_pickup_time.tr(),
                      DateTimeFormatter.parseOrderCreatedDate(order.fulfillmentExpectedPickupTime),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: mediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        SizedBox(height: AppSize.s2.rh),
        Text(
          description,
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ],
    );
  }
}
