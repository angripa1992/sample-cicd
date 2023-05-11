import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
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
          color: AppColors.whiteSmoke,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.frenchGrey,
              size: AppSize.s16.rSp,
            ),
            SizedBox(width: AppSize.s8.rw),
            Text(
              'Search for items and categories',
              style: getRegularTextStyle(
                color: AppColors.frenchGrey,
                fontSize: AppSize.s14.rSp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
