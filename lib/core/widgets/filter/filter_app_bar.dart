import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/base/kt_app_bar.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function() clearAll;

  const FilterAppBar({super.key, required this.clearAll});

  @override
  Widget build(BuildContext context) {
    return KTAppBar(
      title: 'Filter',
      centerTitle: true,
      height: kToolbarHeight + AppSize.s6.rh,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppSize.s6.rh),
          child: Divider(
            thickness: AppSize.s6.rh,
            height: AppSize.s6.rh,
            color: AppColors.neutralB30,
          )),
      actions: [
        TextButton(
          onPressed: clearAll,
          child: Text(
            'Clear all',
            style: semiBoldTextStyle(color: AppColors.primary),
          ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s16.rw),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + AppSize.s6.rh);
}
