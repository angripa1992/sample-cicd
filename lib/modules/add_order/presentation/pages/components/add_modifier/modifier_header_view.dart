import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class ModifierHeaderView extends StatelessWidget {
  final VoidCallback onBack;
  final String itemName;
  final VoidCallback onCartClick;
  const ModifierHeaderView(
      {Key? key, required this.onBack, required this.itemName, required this.onCartClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.s1.rh),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightGrey,
            offset: const Offset(0.0, 2.0),
            blurRadius: 2.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.purpleBlue,
              ),
            ),
            Expanded(
              child: Text(
                itemName,
                style: getRegularTextStyle(
                  color: AppColors.balticSea,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            ),
            IconButton(onPressed: onCartClick, icon: Icon(Icons.add_shopping_cart)),
          ],
        ),
      ),
    );
  }
}
