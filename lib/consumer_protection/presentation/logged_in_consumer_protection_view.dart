import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/assets.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../data/model/consumer_protection.dart';

class LoggedInConsumerProtectionView extends StatelessWidget {
  final ConsumerProtection consumerProtection;

  const LoggedInConsumerProtectionView(
      {Key? key, required this.consumerProtection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppSize.s24.rh),
          child: Text(
            consumerProtection.header,
            style: getBoldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s12.rh),
            child: Image.asset(
              AppImages.klikitTextPurple,
              height: AppSize.s24.rh,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Row(
          children: [
            Icon(
              Icons.phone,
              color: AppColors.black,
              size: AppSize.s16.rSp,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
              child: Text(
                consumerProtection.orgPhone,
                style: getRegularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.s8.rh),
        Row(
          children: [
            Icon(
              Icons.email_outlined,
              color: AppColors.black,
              size: AppSize.s16.rSp,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
              child: Text(
                consumerProtection.orgEmail,
                textAlign: TextAlign.center,
                style: getRegularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s12.rh),
          child: Text(
            consumerProtection.directorateTitle,
            style: getMediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
        Text(
          consumerProtection.directorateSubtitle,
          style: getMediumTextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.s12.rh),
          child: Text(
            consumerProtection.directorateSocialContact,
            style: getMediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        ),
      ],
    );
  }
}
