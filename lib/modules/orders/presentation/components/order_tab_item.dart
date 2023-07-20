import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../resources/colors.dart';
import '../../../../resources/fonts.dart';
import '../../../../resources/values.dart';

class OrderTabItem extends StatelessWidget {
  final String title;
  final int count;

  const OrderTabItem({
    Key? key,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
        ),
        if (count > 0) SizedBox(width: AppSize.s6.rw),
        if (count > 0)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s8.rw,
              vertical: AppSize.s1.rh,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s4.rSp),
              color: AppColors.purpleBlue,
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: AppFontSize.s12.rSp,
                fontFamily: AppFonts.Aeonik,
                fontWeight: AppFontWeight.regular,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }
}
