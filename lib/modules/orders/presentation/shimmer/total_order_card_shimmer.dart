import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../widgets/shimmer/container_shimmer.dart';

class TotalOrderCardShimmer extends StatelessWidget {
  final String text;
  final String orders;
  final Color orderColor;
  final Color? textColor;
  final Color? bgColor;
  final double orderFontSize;
  final double fontSize;
  final double height;
  final double width;

  const TotalOrderCardShimmer(
      {Key? key,
      required this.text,
      required this.orders,
      required this.orderColor,
      this.textColor,
      this.bgColor,
      required this.orderFontSize,
      required this.fontSize,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        color: bgColor ?? AppColors.white,
        shadowColor: AppColors.smokeyGrey,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s12.rw,
            vertical: AppSize.s10.rh,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ContainerShimmer(
                baseColor: AppColors.lightGrey,
                highlightColor: AppColors.whiteSmoke,
                height: AppFontSize.s14.rh,
                width: AppSize.s32.rw,
              ),
              SizedBox(height: AppSize.s8.rh),
              Shimmer.fromColors(
                baseColor: textColor ?? AppColors.blackCow,
                highlightColor: AppColors.whiteSmoke,
                enabled: true,
                child: Text(
                  text,
                  style: getRegularTextStyle(
                    color: AppColors.blackCow,
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
