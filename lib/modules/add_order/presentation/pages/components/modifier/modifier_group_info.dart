import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/modifier/modifier_rule.dart';

class ModifierGroupInfo extends StatelessWidget {
  final String title;
  final AddOrderItemModifierRule rule;

  const ModifierGroupInfo({Key? key, required this.title, required this.rule})
      : super(key: key);

  String _ruleTitle() {
    final optional = rule.min == 0;
    if (optional) {
      return '${AppStrings.choose_upto.tr()} ${rule.max}';
    } else if (rule.min == rule.max) {
      return '${AppStrings.choose.tr()} ${rule.min}';
    }
    return '${AppStrings.choose.tr()} ${rule.min} - ${rule.max}';
  }

  @override
  Widget build(BuildContext context) {
    final isOptional = rule.min == 0;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.s8.rSp),
          topRight: Radius.circular(AppSize.s8.rSp),
        ),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s12.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: mediumTextStyle(
                      color: AppColors.balticSea,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                      color: isOptional
                          ? AppColors.lightGrey
                          : AppColors.blueChalk,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.s2.rh,
                        horizontal: AppSize.s8.rw,
                      ),
                      child: Text(
                        isOptional
                            ? AppStrings.optional.tr()
                            : AppStrings.required.tr(),
                        style: regularTextStyle(
                          color: isOptional
                              ? AppColors.smokeyGrey
                              : AppColors.purpleBlue,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: AppSize.s2.rh),
            Text(
              _ruleTitle(),
              style: regularTextStyle(
                color: AppColors.smokeyGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
