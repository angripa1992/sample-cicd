import 'package:flutter/material.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class CheckoutAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const CheckoutAppBar({Key? key, required this.onBack}) : super(key: key);

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
            IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Place Order',
                  style: getMediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s17.rSp,
                  ),
                ),
                Text(
                  SessionManager().currentUserBranchName(),
                  style: getMediumTextStyle(
                    color: AppColors.dustyGreay,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}