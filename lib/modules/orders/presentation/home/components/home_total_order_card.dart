import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class HomeTotalOrdersCard extends StatelessWidget {
  final int totalOrderToday;
  final int totalOrderYesterday;
  final VoidCallback onTap;

  const HomeTotalOrdersCard(
      {Key? key,
      required this.totalOrderToday,
      required this.totalOrderYesterday, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shadowColor: AppColors.smokeyGrey,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s20.rw,
            vertical: AppSize.s20.rh,
          ),
          child: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.total_orders_today.tr(),
                    style: getRegularTextStyle(
                      color: AppColors.blackCow,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                  Text(
                    totalOrderToday.toString(),
                    style: getRegularTextStyle(
                      color: AppColors.purpleBlue,
                      fontSize: AppFontSize.s30.rSp,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.yesterday.tr(),
                    style: getRegularTextStyle(
                      color: AppColors.coolGrey,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                  Text(
                    totalOrderToday.toString(),
                    style: getRegularTextStyle(
                      color: AppColors.coolGrey,
                      fontSize: AppFontSize.s17.rSp,
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppSize.s8.rw),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.coolGrey,
                size: AppSize.s20.rSp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
