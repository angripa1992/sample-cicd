import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/modifier/modifier_group.dart';
import 'modifer_switch_view.dart';

class ModifierGroupInfoView extends StatelessWidget {
  final int brandId;
  final int branchID;
  final ModifierGroup modifiersGroup;
  final Function(ModifierGroup) onChanged;

  const ModifierGroupInfoView({
    Key? key,
    required this.modifiersGroup,
    required this.brandId,
    required this.onChanged,
    required this.branchID,
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
                padding: EdgeInsets.symmetric(horizontal: 8.rw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      modifiersGroup.title,
                      style: mediumTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s16.rSp,
                      ),
                    ),
                    SizedBox(height: 6.rh),
                    Text(
                      '${modifiersGroup.modifiers.length} Modifiers',
                      style: regularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ModifierSwitchView(
              menuVersion: modifiersGroup.menuVersion,
              branchID: branchID,
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
      ],
    );
  }
}
