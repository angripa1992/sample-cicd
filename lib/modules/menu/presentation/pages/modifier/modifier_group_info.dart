import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import 'modifer_switch_view.dart';

class ModifierGroupInfoView extends StatelessWidget {
  final int brandId;
  final int providerId;
  final ModifiersGroup modifiersGroup;
  final Function(ModifiersGroup) onChanged;

  const ModifierGroupInfoView({
    Key? key,
    required this.modifiersGroup,
    required this.brandId,
    required this.onChanged,
    required this.providerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                child: Text(
                  AppStrings.name.tr(),
                  style: regularTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
            ),
            ModifierSwitchView(
              providerId: providerId,
              brandId: brandId,
              groupId: modifiersGroup.groupId,
              enabled: modifiersGroup.statuses.isEmpty
                  ? false
                  : modifiersGroup.statuses[0].enabled,
              type: ModifierType.GROUP,
              onSuccess: (enabled) {
                modifiersGroup.statuses[0].enabled = enabled;
                onChanged(modifiersGroup);
              },
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(AppSize.s4.rSp)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s12.rw,
            ),
            child: Text(
              modifiersGroup.title,
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
