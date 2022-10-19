import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/components/busy_mode_view.dart';
import 'package:klikit/modules/orders/presentation/order/components/filter/brand_filter.dart';
import 'package:klikit/modules/orders/presentation/order/components/filter/delivery_platform_filter.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_subject.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import 'order_status_filter.dart';

class OrderHeaderView extends StatelessWidget {
  final FilterSubject subject;

  const OrderHeaderView({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // const OrderAppBar(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s12.rw,
            vertical: AppSize.s16.rh,
          ),
          child: BrandFilter(
            filterSubject: subject,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: AppSize.s12.rw,
            left: AppSize.s12.rw,
          ),
          child: DeliveryPlatformFilter(filterSubject: subject),
        ),

        // Padding(
        //   padding: EdgeInsets.only(
        //     right: AppSize.s12.rw,
        //     left: AppSize.s12.rw,
        //   ),
        //   child:  OrderStatusFilter(),
        // ),

        // Padding(
        //   padding: EdgeInsets.only(
        //     left: AppSize.s12.rw,
        //     right: AppSize.s12.rw,
        //     top: AppSize.s16.rh,
        //   ),
        //   child: TotalOrderView(subject: subject),
        // ),
        Padding(
          padding: EdgeInsets.only(
            right: AppSize.s12.rw,
            left: AppSize.s16.rw,
            top: AppSize.s12.rw,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Orders',
                style: getRegularTextStyle(
                  color: AppColors.purpleBlue,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              const BusyModeView(),
            ],
          ),
        ),
      ],
    );
  }
}
