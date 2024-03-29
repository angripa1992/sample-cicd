import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import 'discount_type_selector.dart';

class AddDiscountModalView extends StatelessWidget {
  final int initialType;
  final Function(int) onTypeChanged;
  final TextEditingController discountValueController;

  const AddDiscountModalView({
    Key? key,
    required this.initialType,
    required this.onTypeChanged,
    required this.discountValueController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.discount.tr(),
              style: mediumTextStyle(
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            SizedBox(height: AppSize.s2.rh),
            Text(
              AppStrings.select_one_and_put_the_value.tr(),
              style: regularTextStyle(
                fontSize: AppFontSize.s12.rSp,
                color: AppColors.greyDarker,
              ),
            ),
            DiscountTypeSelector(
              initValue: initialType,
              onChange: onTypeChanged,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: AppColors.greyLighter,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s8.rw,
                ),
                child: TextField(
                  controller: discountValueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '${AppStrings.add.tr()} ${AppStrings.discount.tr()}',
                    hintStyle: regularTextStyle(
                      color: AppColors.greyDarker,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
