import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/components/busy_mode_view.dart';
import 'package:klikit/modules/orders/presentation/order/components/brand_filter.dart';
import 'package:klikit/modules/orders/presentation/order/components/delivery_platform_filter.dart';
import 'package:klikit/modules/orders/presentation/order/components/order_app_bar.dart';
import 'package:klikit/modules/orders/presentation/order/components/total_orders.dart';
import 'package:klikit/resources/values.dart';

class OrderHeaderView extends StatefulWidget {
  const OrderHeaderView({Key? key}) : super(key: key);

  @override
  State<OrderHeaderView> createState() => _OrderHeaderViewState();
}

class _OrderHeaderViewState extends State<OrderHeaderView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OrderAppBar(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s20.rw,
            vertical: AppSize.s12.rh,
          ),
          child: const DeliveryPlatformFilter(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s20.rw,
            vertical: AppSize.s8.rh,
          ),
          child: const BrandFilter(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s18.rw,
            vertical: AppSize.s8.rh,
          ),
          child: const TotalOrderView(),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: AppSize.s18.rw,
            left: AppSize.s18.rw,
            top: AppSize.s8.rw,
          ),
          child: const BusyModeView(),
        ),
      ],
    );
  }
}
