import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_item_details.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
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
  void _showItemDetails(int index) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(14.rSp),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: ScreenSizes.screenHeight / 1.5,
          child: ModifierItemDetails(
            item: widget.modifierGroup.modifiers[index],
            groupID: widget.modifierGroup.id,
            menuVersion: widget.modifierGroup.menuVersion,
            brandID: widget.brandId,
            branchID: widget.branchID,
            onEnabledChanged: (enabled) {
              setState(() {
                widget.modifierGroup.modifiers[index].isEnabled = enabled;
                widget.onChanged(widget.modifierGroup.modifiers);
              });
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: UniqueKey(),
      separatorBuilder: (_, __) => const Divider(),
      itemCount: widget.modifierGroup.modifiers.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.rh),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (widget.modifierGroup.menuVersion == MenuVersion.v2) {
                      _showItemDetails(index);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.rw),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.modifierGroup.modifiers[index].title.trim(),
                          style: mediumTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s16.rSp,
                          ),
                        ),
                        SizedBox(height: 4.rh),
                        Text(
                          widget.modifierGroup.modifiers[index].klikitPrice(),
                          style: regularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      ],
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
        );
      },
    );
  }
}
