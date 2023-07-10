import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../resources/values.dart';

class OrdersCard extends StatelessWidget {
  final String text;
  final String orders;
  final Color orderColor;
  final Color? textColor;
  final Color? bgColor;
  final double orderFontSize;
  final double fontSize;
  final double height;
  final double width;

  const OrdersCard(
      {Key? key,
      required this.text,
      required this.orders,
      required this.orderColor,
      required this.fontSize,
      required this.orderFontSize,
      required this.height,
      required this.width,
      this.textColor,
      this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          color: bgColor ?? AppColors.white,
          border: Border.all(color: AppColors.whiteSmoke, width: 2),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s12.rw,
            vertical: AppSize.s10.rh,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                orders,
                style: regularTextStyle(
                  color: orderColor,
                  fontSize: orderFontSize,
                ),
              ),
              SizedBox(height: AppSize.s8.rh),
              Expanded(
                child: Text(
                  text,
                  style: regularTextStyle(
                    color: textColor ?? AppColors.blackCow,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
