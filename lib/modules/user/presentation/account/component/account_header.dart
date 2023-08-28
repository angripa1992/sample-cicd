import 'package:flutter/material.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = SessionManager().user();
    return Column(
      children: [
        Text(
          '${userInfo.firstName} ${userInfo.lastName}',
          style: boldTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s18.rSp,
          ),
        ),
        SizedBox(height: AppSize.s4.rh),
        Text(
          userInfo.email,
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(height: AppSize.s4.rh),
        Text(
          userInfo.displayRoles.first,
          style: regularTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
      ],
    );
  }
}
