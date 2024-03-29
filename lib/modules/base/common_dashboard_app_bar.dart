import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/base/order_counter.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class CommonDashboardAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function()? onNavBack;
  final Function()? onCartTap;

  const CommonDashboardAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.onNavBack,
    this.onCartTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.only(left: (onNavBack != null) ? 0 : AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s8.rh, bottom: AppSize.s8.rh),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (onNavBack != null)
              IconButton(
                onPressed: onNavBack,
                icon: const Icon(Icons.arrow_back),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Text(title, style: semiBoldTextStyle(fontSize: AppSize.s18.rSp, color: AppColors.neutralB700)),
                if (subtitle != null)
                  Text(subtitle!, style: regularTextStyle(fontSize: 12, color: AppColors.neutralB500)).setVisibilityWithSpace(
                    direction: Axis.vertical,
                    startSpace: AppSize.s6,
                  ),
              ],
            ),
            const Spacer(),
            AppSize.s8.horizontalSpacer(),
            if (!UserPermissionManager().isBizOwner())
              OrderCounter(
                onCartTap: onCartTap != null
                    ? onCartTap!
                    : () {
                        Navigator.of(context).pushNamed(Routes.addOrder);
                      },
              ),
          ],
        ),
      ),
    );
  }
}
