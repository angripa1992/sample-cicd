import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/base/order_counter.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/values.dart';

class BaseScreenAppBar extends StatelessWidget {
  const BaseScreenAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 16.rw, right: 16.rw, top: 10.rh, bottom: 12.rh),
        color: AppColors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ImageResourceResolver.appLogoSVG.getImageWidget(width: AppSize.s26.rw, height: AppSize.s24.rh),
            8.horizontalSpacer(),
            ImageResourceResolver.appWordMarkSVG.getImageWidget(width: 52.rw, height: AppSize.s18.rh),
            const Spacer(),
            if (!UserPermissionManager().isBizOwner())
              OrderCounter(onCartTap: () {
                Navigator.of(context).pushNamed(Routes.addOrder);
              }),
          ],
        ),
      ),
    );
  }
}
