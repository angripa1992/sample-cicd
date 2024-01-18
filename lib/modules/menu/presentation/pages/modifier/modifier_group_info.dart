import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/modifier/modifier_group.dart';
import 'modifer_switch_view.dart';

class ModifierGroupInfoView extends StatelessWidget {
  final int brandId;
  final int providerId;
  final ModifierGroup modifiersGroup;
  final Function(ModifierGroup) onChanged;

  const ModifierGroupInfoView({
    Key? key,
    required this.modifiersGroup,
    required this.brandId,
    required this.onChanged,
    required this.providerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw, vertical: AppSize.s8.rh),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modifiersGroup.title.trim(),
                  style: mediumTextStyle(
                    color: AppColors.neutralB600,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
                Text(
                  '${modifiersGroup.modifiers.length} ${modifiersGroup.modifiers.length > 1 ? AppStrings.modifiers.tr() : AppStrings.modifier.tr()}',
                  style: regularTextStyle(
                    color: AppColors.neutralB300,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ],
            ),
          ),
          ModifierSwitchView(
            menuVersion: modifiersGroup.menuVersion,
            providerId: providerId,
            brandId: brandId,
            groupId: modifiersGroup.id,
            enabled: modifiersGroup.isEnabled,
            type: ModifierType.GROUP,
            onSuccess: (enabled) {
              modifiersGroup.isEnabled = enabled;
              onChanged(modifiersGroup);
            },
          ),
        ],
      ),
    );
  }
}
