import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/components/busy_mode_view.dart';
import 'package:klikit/modules/orders/presentation/order/components/brand_filter.dart';
import 'package:klikit/modules/orders/presentation/order/components/delivery_platform_filter.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_app_bar.dart';
import 'package:klikit/modules/orders/presentation/order/components/total_orders.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_subject.dart';
import 'package:klikit/resources/values.dart';

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
          child: BrandFilter(filterSubject: subject,),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: AppSize.s12.rw,
            left: AppSize.s12.rw,
          ),
          child: DeliveryPlatformFilter(filterSubject: subject),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppSize.s12.rw,
            right: AppSize.s12.rw,
            top: AppSize.s16.rh,
          ),
          child: TotalOrderView(subject: subject),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: AppSize.s12.rw,
            left: AppSize.s12.rw,
            top: AppSize.s12.rw,
          ),
          child: const BusyModeView(),
        ),
      ],
    );
  }
}
