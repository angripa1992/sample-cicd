import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/order.dart';
import 'order_item_view.dart';

class ScheduleOrderItemView extends StatelessWidget {
  final VoidCallback seeDetails;
  final VoidCallback onPrint;
  final Order order;

  const ScheduleOrderItemView({
    Key? key,
    required this.order,
    required this.seeDetails,
    required this.onPrint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: OrderItemView(order: order, seeDetails: seeDetails),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: AppSize.s16.rw),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scheduled',
                      style: getMediumTextStyle(
                        color: AppColors.dustyOrange,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: AppSize.s16.rSp,
                            color: AppColors.purpleBlue,
                          ),
                          SizedBox(width: AppSize.s4.rw),
                          Flexible(
                            child: Text(
                              DateTimeProvider.scheduleDate(
                                  order.scheduledTime),
                              style: getMediumTextStyle(
                                color: AppColors.purpleBlue,
                                fontSize: AppFontSize.s14.rSp,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: AppSize.s16.rSp,
                          color: AppColors.purpleBlue,
                        ),
                        SizedBox(width: AppSize.s4.rw),
                        Flexible(
                          child: Text(
                            DateTimeProvider.scheduleTime(order.scheduledTime),
                            style: getMediumTextStyle(
                              color: AppColors.purpleBlue,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(thickness: AppSize.s1),
      ],
    );
  }
}
