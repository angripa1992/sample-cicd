import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

class OrderItemShimmer extends StatelessWidget {
  const OrderItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.s8.rh),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: AppSize.s40.rw,
            height: AppSize.s40.rh,
            color: AppColors.white,
          ),
          SizedBox(width: AppSize.s8.rw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: AppSize.s8.rw,
                  color: AppColors.white,
                ),
                SizedBox(height: AppSize.s8.rw),
                Container(
                  width: AppSize.s40.rw,
                  height: AppSize.s8.rw,
                  color: AppColors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
