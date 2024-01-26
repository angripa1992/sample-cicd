import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/modules/common/entities/brand.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class CartItemBrand extends StatelessWidget {
  final Brand menuBrand;
  final Function(int) removeAll;

  const CartItemBrand({Key? key, required this.menuBrand, required this.removeAll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
          child: Row(
            children: [
              KTNetworkImage(imageUrl: menuBrand.logo,height: 32.rSp,width: 32.rSp,imageBorderWidth: 1),
              SizedBox(width: 12.rw),
              Expanded(
                child: Text(
                  menuBrand.title,
                  style: mediumTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
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
