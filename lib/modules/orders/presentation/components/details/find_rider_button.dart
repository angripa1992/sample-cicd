import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class FindRiderView extends StatelessWidget {
  final VoidCallback onRiderFind;
  const FindRiderView({Key? key, required this.onRiderFind}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRiderFind,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s6.rh,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          color: AppColors.dawnPink,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delivery_dining_rounded,
              color: AppColors.blackCow,
              size: AppSize.s16.rSp,
            ),
            SizedBox(width: AppSize.s8.rw),
            Flexible(
              child: Text(
                'Find Rider',
                style: getRegularTextStyle(
                  color: AppColors.blackCow,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
