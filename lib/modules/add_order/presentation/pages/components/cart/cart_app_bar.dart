import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class CartAppBar extends StatelessWidget {
  final VoidCallback onClose;

  const CartAppBar({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
        child: Row(
          children: [
            IconButton(onPressed: onClose, icon: const Icon(Icons.clear)),
            Text(
              AppStrings.cart,
              style: getMediumTextStyle(
                color: AppColors.balticSea,
                fontSize: AppFontSize.s17.rSp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
