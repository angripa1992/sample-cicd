import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

void showItemLevelCitizenDiscountDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s16.rSp),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: ItemLevelCitizenDiscountDialogContent(),
      );
    },
  );
}

class ItemLevelCitizenDiscountDialogContent extends StatelessWidget {
  const ItemLevelCitizenDiscountDialogContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'SC Discount',
                style: mediumTextStyle(
                  color: AppColors.bluewood,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Icon(Icons.clear),
            ),
          ],
        ),
        Text(
          'Add no of orders you want to apply',
          style: regularTextStyle(
            color: AppColors.bluewood,
            fontSize: AppFontSize.s14.rSp,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s10.rw,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.dustyGreay),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.dustyGreay),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.dustyGreay),
            ),
          ),
        ),
      ],
    );
  }
}
