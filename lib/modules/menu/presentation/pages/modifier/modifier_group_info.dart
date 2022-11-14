import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import 'modifer_switch_view.dart';

class ModifierGroupInfoView extends StatelessWidget {
  final int brandId;
  final ModifiersGroup modifiersGroup;
  final Function(ModifiersGroup) onChanged;

  const ModifierGroupInfoView(
      {Key? key,
      required this.modifiersGroup,
      required this.brandId,
      required this.onChanged})
      : super(key: key);

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
                  'Name',
                  style: getRegularTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
            ),
            ModifierSwitchView(
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
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(AppSize.s4.rSp)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s12.rw,
            ),
            child: Text(
              modifiersGroup.title,
              style: getRegularTextStyle(
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
