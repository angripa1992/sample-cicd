import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class SearchActionButtonView extends StatelessWidget {
  final VoidCallback onTap;

  const SearchActionButtonView({Key? key, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s10.rw,
          vertical: AppSize.s10.rh,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          border: Border.all(color: AppColors.neutralB40)
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.greyDarker,
              size: 24.rSp,
            ),
            SizedBox(width: 8.rw),
            Text(
              AppStrings.search_for_items.tr(),
              style: regularTextStyle(
                color: AppColors.neutralB100,
                fontSize: 14.rSp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
