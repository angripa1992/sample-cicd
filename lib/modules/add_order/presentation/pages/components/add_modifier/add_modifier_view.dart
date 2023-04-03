import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/add_modifier/level_one_select_one_view.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/items.dart';
import '../../../../domain/entities/item_modifier_group.dart';
import 'item_description_view.dart';
import 'level_one_select_multiple_view.dart';
import 'modifier_group_info.dart';
import 'modifier_header_view.dart';

class AddModifierView extends StatelessWidget {
  final List<ItemModifierGroup> groups;
  final MenuItems item;
  final VoidCallback onClose;

  const AddModifierView(
      {Key? key,
      required this.groups,
      required this.item,
      required this.onClose})
      : super(key: key);

  Future<bool> _verify() async {
    for (var groupLevelOne in groups) {
      int levelOneModifierQuantity = 0;
      for (var modifierLevelOne in groupLevelOne.modifiers) {
        debugPrint("Level 1 -> ${modifierLevelOne.title} -> ${modifierLevelOne.isSelected} -> ${modifierLevelOne.quantity}");
        if (modifierLevelOne.isSelected) {
          levelOneModifierQuantity += modifierLevelOne.quantity;
          for (var groupLevelTwo in modifierLevelOne.groups) {
            int levelTwoModifierQuantity = 0;
            for (var modifierLevelTwo in groupLevelTwo.modifiers) {
              debugPrint("Level 2 -> ${modifierLevelTwo.title} -> ${modifierLevelTwo.isSelected} -> ${modifierLevelTwo.quantity}");
              if (modifierLevelTwo.isSelected) {
                levelTwoModifierQuantity += modifierLevelTwo.quantity;
              }
            }
            if (!_checkRole(levelTwoModifierQuantity, groupLevelTwo)) {
              return false;
            }
          }
        }
      }
      if (!_checkRole(levelOneModifierQuantity, groupLevelOne)) {
        return false;
      }
    }
    return true;
  }

  bool _checkRole(int quantity, ItemModifierGroup group) {
    final rule = group.rule;
    debugPrint(
        '${group.title} ->  rule -> value = ${rule.value} -> min = ${rule.min} -> max = ${rule.max} -> quantity = $quantity');
    if (rule.value > 0 && rule.value == quantity) {
      return true;
    } else if (rule.value == 0 &&
        rule.min <= quantity &&
        rule.max >= quantity) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGrey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ModifierHeaderView(
            onBack: onClose,
            itemName: item.title,
            onCartClick: () async {
              print("is ok -> ${await _verify()}");
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ItemDescriptionView(item: item),
                  Column(
                    children: groups.map((group) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: AppSize.s8.rh,
                          left: AppSize.s10.rw,
                          right: AppSize.s10.rw,
                        ),
                        child: Column(
                          children: [
                            ModifierGroupInfo(
                              title: group.title,
                              rule: group.rule,
                            ),
                            (group.rule.typeTitle == RuleType.exact &&
                                    group.rule.value == 1)
                                ? LevelOneSelectOneView(
                                    modifiers: group.modifiers,
                                  )
                                : LevelOneSelectMultipleView(
                                    modifiers: group.modifiers,
                                  ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
