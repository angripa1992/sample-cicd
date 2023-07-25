import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class AccountSettingItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;

  const AccountSettingItem(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s12.rw,
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColors.blackCow,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s16.rw,
                ),
                child: Text(
                  title,
                  style: mediumTextStyle(
                    color: AppColors.blackCow,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.blackCow,
            ),
          ],
        ),
      ),
    );
  }
}
