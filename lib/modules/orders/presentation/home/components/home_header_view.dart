import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/values.dart';

class HomeHeaderView extends StatelessWidget {
  final UserInfo userInfo;

  const HomeHeaderView({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      height: 23.h,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s24.rw,
          vertical: AppSize.s24.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${userInfo.firstName} ${userInfo.lastName}',
              style: getRegularTextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.s25.rSp,
              ),
            ),
            SizedBox(height: AppSize.s12.rh,),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppSize.s5.rSp),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s8.rh,
                  horizontal: AppSize.s12.rw,
                ),
                child: Text(
                  '${userInfo.displayRoles[0]}, ${userInfo.businessName}, ${userInfo.branchName} ',
                  style: getRegularTextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
