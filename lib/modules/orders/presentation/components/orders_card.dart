import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../resources/values.dart';

class OrdersCard extends StatelessWidget {
  final String text;
  final String orders;
  final Color orderColor;
  final double orderFontSize;
  final double fontSize;

  const OrdersCard(
      {Key? key,
      required this.text,
      required this.orders,
      required this.orderColor,
      required this.fontSize,
      required this.orderFontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.smokeyGrey,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s18.rw,
          vertical: AppSize.s18.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              orders,
              style: getRegularTextStyle(
                color: orderColor,
                fontSize: orderFontSize,
              ),
            ),
            SizedBox(height: AppSize.s4.rh),
            Text(
              text,
              style: getRegularTextStyle(
                color: AppColors.blackCow,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
