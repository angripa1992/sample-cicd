import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/orders/domain/entities/rider_info.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class RiderInfoView extends StatelessWidget {
  final RiderInfo riderInfo;
  final String? pickUpTime;

  const RiderInfoView({Key? key, required this.riderInfo, this.pickUpTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(color: AppColors.frenchGrey),
          Text(
            'Rider Info',
            style: boldTextStyle(
              color: AppColors.bluewood,
              fontSize: AppFontSize.s15.rSp,
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Row(
            children: [
              Expanded(
                child: _infoItem('Name', riderInfo.name ?? EMPTY),
              ),
              Expanded(
                child: _infoItem('Vehicle Registration', riderInfo.licensePlate ?? EMPTY),
              ),
            ],
          ),
          SizedBox(height: AppSize.s8.rh),
          Row(
            children: [
              Expanded(
                child: _infoItem('Contact', riderInfo.phone ?? EMPTY),
              ),
              if (pickUpTime != null)
                Expanded(
                  child: _infoItem('Estimated Pickup Time',
                      DateTimeProvider.parseOrderCreatedDate(pickUpTime!)),
                ),
            ],
          ),
        ],
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
            color: AppColors.bluewood,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        SizedBox(height: AppSize.s2.rh),
        Text(
          description,
          style: regularTextStyle(
            color: AppColors.bluewood,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
      ],
    );
  }
}
