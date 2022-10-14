import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class OrderStatusView extends StatelessWidget {
  final Order order;

  OrderStatusView({Key? key, required this.order}) : super(key: key);

  final _style = getBoldTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s14.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: (order.isManualOrder || order.type == AppConstant.TYPE_PICKUP),
          child: Padding(
            padding: EdgeInsets.only(top: AppSize.s12.rh),
            child: Text('<Status>', style: _style),
          ),
        ),
        SizedBox(width: AppSize.s24.rw),
        Visibility(
          visible: (order.isManualOrder),
          child: Padding(
            padding: EdgeInsets.only(left: AppSize.s24.rw,top: AppSize.s12.rh),
            child: Text('Manual', style: _style),
          ),
        ),
        SizedBox(width: AppSize.s24.rw),
        Visibility(
          visible: (order.type == AppConstant.TYPE_PICKUP),
          child: Padding(
            padding: EdgeInsets.only(left: AppSize.s24.rw,top: AppSize.s12.rh),
            child: Text('Pickup', style: _style),
          ),
        ),
      ],
    );
  }
}
