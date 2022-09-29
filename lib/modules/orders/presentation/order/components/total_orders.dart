import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../components/orders_card.dart';

class TotalOrderView extends StatefulWidget {
  const TotalOrderView({Key? key}) : super(key: key);

  @override
  State<TotalOrderView> createState() => _TotalOrderViewState();
}

class _TotalOrderViewState extends State<TotalOrderView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenSizes.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          OrdersCard(
            height: AppSize.s96.rh,
            width: AppSize.s107.rw,
            text: 'Total Orders',
            orders: '0',
            orderColor: AppColors.purpleBlue,
            fontSize: AppFontSize.s14.rSp,
            orderFontSize: AppFontSize.s24.rSp,
          ),
          OrdersCard(
            height: AppSize.s96.rh,
            width: AppSize.s107.rw,
            text: 'Completed Orders',
            orders: '0',
            orderColor: AppColors.purpleBlue,
            fontSize: AppFontSize.s14.rSp,
            orderFontSize: AppFontSize.s24.rSp,
          ),
          OrdersCard(
            height: AppSize.s96.rh,
            width: AppSize.s107.rw,
            text: AppStrings.cancelled_orders.tr(),
            orders: '1000',
            orderColor: AppColors.lightViolet,
            fontSize: AppFontSize.s14.rSp,
            orderFontSize: AppFontSize.s24.rSp,
          ),
        ],
      ),
    );
  }
}
