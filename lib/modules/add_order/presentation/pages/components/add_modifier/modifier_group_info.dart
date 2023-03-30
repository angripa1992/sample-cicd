import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/modifier_rule.dart';

class ModifierGroupInfo extends StatelessWidget {
  final String title;
  final ModifierRule rule;

  const ModifierGroupInfo({Key? key, required this.title, required this.rule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOptional = rule.value == 0 && rule.min == 0;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s8.rh,
        horizontal: AppSize.s16.rw,
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
                  style: getMediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s16.rSp),
                    color:
                        isOptional ? AppColors.lightGrey : AppColors.blueChalk,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.s2.rh,
                      horizontal: AppSize.s8.rw,
                    ),
                    child: Text(
                      isOptional ? 'Optional' : 'Required',
                      style: getRegularTextStyle(
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
            rule.title,
            style: getRegularTextStyle(
              color: AppColors.smokeyGrey,
            ),
          ),
        ],
      ),
    );
  }
}
