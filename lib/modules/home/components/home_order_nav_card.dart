import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class HomeOrderNavCard extends StatelessWidget {
  final String numberOfOrders;
  final String text;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const HomeOrderNavCard(
      {Key? key,
      required this.numberOfOrders,
      required this.bgColor,
      required this.textColor,
      required this.onTap,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: bgColor,
        shadowColor: AppColors.smokeyGrey,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s20.rw,
            vertical: AppSize.s12.rh,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: getRegularTextStyle(
                    color: textColor,
                    fontSize: AppFontSize.s15.rSp,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                numberOfOrders,
                style: getRegularTextStyle(
                  color: textColor,
                  fontSize: AppFontSize.s25.rSp,
                ),
              ),
              SizedBox(width: AppSize.s20.rw),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
