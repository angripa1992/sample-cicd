import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class CartItemBrand extends StatelessWidget {
  final MenuBrand menuBrand;
  final Function(int) removeAll;

  const CartItemBrand(
      {Key? key, required this.menuBrand, required this.removeAll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  menuBrand.title,
                  style: boldTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s15.rSp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  removeAll(menuBrand.id);
                },
                child: Text(
                  AppStrings.remove_all.tr(),
                  style: mediumTextStyle(
                    color: AppColors.red,
                  ),
                ),
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
