import 'package:flutter/material.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/values.dart';
import '../../../add_order/presentation/pages/components/cart_badge.dart';

class HomeHeaderView extends StatelessWidget {
  final VoidCallback onCartTap;

  const HomeHeaderView({Key? key, required this.onCartTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black,
      padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 8.rh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  SessionManager().userName(),
                  style: regularTextStyle(
                    color: AppColors.white,
                    fontSize: AppFontSize.s25.rSp,
                  ),
                ),
              ),
              if (!UserPermissionManager().isBizOwner())
                CartBadge(
                  iconColor: AppColors.white,
                  onCartTap: onCartTap,
                ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: AppSize.s16.rw,top: 8.rh),
            decoration: BoxDecoration(
              color: AppColors.graniteGrey,
              borderRadius: BorderRadius.circular(AppSize.s5.rSp),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s8.rh,
                horizontal: AppSize.s12.rw,
              ),
              child: Text(
                UserPermissionManager().isBizOwner()
                    ? '${SessionManager().userDisplayRole()}, ${SessionManager().businessName()}'
                    : '${SessionManager().userDisplayRole()}, ${SessionManager().businessName()}, ${SessionManager().branchName()}',
                style: regularTextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
