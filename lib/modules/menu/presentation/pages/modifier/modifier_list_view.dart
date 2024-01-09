import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/modifier/grouped_modifier_item.dart';
import '../../../domain/entities/modifier/modifier_group.dart';
import 'modifer_switch_view.dart';

class ModifierListView extends StatefulWidget {
  final int brandId;
  final int branchID;
  final ModifierGroup modifierGroup;
  final Function(List<GroupedModifierItem>) onChanged;

  const ModifierListView({
    Key? key,
    required this.modifierGroup,
    required this.brandId,
    required this.onChanged,
    required this.branchID,
  }) : super(key: key);

  @override
  State<ModifierListView> createState() => _ModifierListViewState();
}

class _ModifierListViewState extends State<ModifierListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: AppSize.s8.rh),
        child: ListView.builder(
          key: UniqueKey(),
          itemCount: widget.modifierGroup.modifiers.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                        child: Text(
                          widget.modifierGroup.modifiers[index].title,
                          style: regularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      ),
                    ),
                    ModifierSwitchView(
                      menuVersion: widget.modifierGroup.menuVersion,
                      branchID: widget.branchID,
                      brandId: widget.brandId,
                      groupId: widget.modifierGroup.id,
                      modifierId: widget.modifierGroup.modifiers[index].id,
                      enabled: widget.modifierGroup.modifiers[index].isEnabled,
                      type: ModifierType.MODIFIER,
                      onSuccess: (enabled) {
                        setState(() {
                          widget.modifierGroup.modifiers[index].isEnabled = enabled;
                          widget.onChanged(widget.modifierGroup.modifiers);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
