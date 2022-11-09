import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class SubMenuItemsTitle extends StatelessWidget {
  final SubSections subSections;

  const SubMenuItemsTitle({Key? key, required this.subSections})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.purpleBlue,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: AppSize.s12.rh,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                subSections.title,
                style: getRegularTextStyle(
                  color: AppColors.white,
                  fontSize: AppFontSize.s15.rSp,
                ),
              ),
            ),
            Text(
              '${subSections.items.length} items',
              style: getRegularTextStyle(
                color: AppColors.white,
                fontSize: AppFontSize.s15.rSp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
