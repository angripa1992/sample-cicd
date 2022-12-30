import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class AccountActionItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  const AccountActionItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Center(
              child: Card(
                color: AppColors.blueChalk,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s100),
                ),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s10.rw,
                    vertical: AppSize.s8.rh,
                  ),
                  child: Icon(
                    iconData,
                    size: AppSize.s24.rSp,
                    color: AppColors.purpleBlue,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s8.rw,
                vertical: AppSize.s8.rh,
              ),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: getRegularTextStyle(
                    color: AppColors.purpleBlue,
                    fontSize: AppFontSize.s14.rSp,
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
