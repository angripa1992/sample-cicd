import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/image_url_provider.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = SessionManager().user();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        KTNetworkImage(
          width: 48.rSp,
          height: 48.rSp,
          imageUrl: ImageUrlProvider.getUrl(userInfo?.profilePic ?? ""),
          boxShape: BoxShape.circle,
          widgetPadding: 16.rSp,
        ),
        17.rw.horizontalSpacer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${userInfo!.firstName} ${userInfo.lastName}',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              SizedBox(height: AppSize.s4.rh),
              Text(
                userInfo.email,
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s12.rSp,
                ),
              ),
              SizedBox(height: AppSize.s4.rh),
              Text(
                userInfo.displayRoles.first,
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
