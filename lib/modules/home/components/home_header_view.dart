import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/values.dart';
import '../../add_order/presentation/pages/components/cart_badge.dart';

class HomeHeaderView extends StatelessWidget {
  final UserInfo userInfo;
  final VoidCallback onCartTap;
  const HomeHeaderView({Key? key, required this.userInfo, required this.onCartTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSize.s16.rw,
          top: AppSize.s16.rh,
          bottom: AppSize.s75.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${userInfo.firstName} ${userInfo.lastName}',
                    style: regularTextStyle(
                      color: AppColors.white,
                      fontSize: AppFontSize.s25.rSp,
                    ),
                  ),
                ),
                CartBadge(
                  iconColor: AppColors.white,
                  onCartTap: onCartTap,
                ),
              ],
            ),
            SizedBox(
              height: AppSize.s12.rh,
            ),
            Container(
              margin: EdgeInsets.only(right: AppSize.s16.rw),
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
                  style: regularTextStyle(
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
