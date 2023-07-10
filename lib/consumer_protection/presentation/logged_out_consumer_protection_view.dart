import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../data/model/consumer_protection.dart';

class LoggedOutConsumerProtectionView extends StatelessWidget {
  final ConsumerProtection consumerProtection;

  const LoggedOutConsumerProtectionView(
      {Key? key, required this.consumerProtection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppSize.s16.rh),
          child: Text(
            consumerProtection.header,
            textAlign: TextAlign.center,
            style: boldTextStyle(color: AppColors.white),
          ),
        ),
        SizedBox(
          height: AppSize.s42.rh,
          child: Image.asset(AppImages.klikitTextWhite),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              color: AppColors.white,
              size: AppSize.s14.rSp,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
              child: Text(
                consumerProtection.orgPhone,
                textAlign: TextAlign.center,
                style: regularTextStyle(color: AppColors.white),
              ),
            ),
            SizedBox(width: AppSize.s16.rw),
            Icon(
              Icons.email_outlined,
              color: AppColors.white,
              size: AppSize.s14.rSp,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
              child: Text(
                consumerProtection.orgEmail,
                textAlign: TextAlign.center,
                style: regularTextStyle(color: AppColors.white),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
          child: Text(
            consumerProtection.directorateTitle,
            textAlign: TextAlign.center,
            style: mediumTextStyle(color: AppColors.white),
          ),
        ),
        Text(
          consumerProtection.directorateSubtitle,
          textAlign: TextAlign.center,
          style: mediumTextStyle(color: AppColors.white),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
          child: Text(
            consumerProtection.directorateSocialContact,
            textAlign: TextAlign.center,
            style: mediumTextStyle(color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
