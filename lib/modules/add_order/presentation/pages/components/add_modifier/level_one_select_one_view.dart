import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/item_modifier_group.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/item_modifier.dart';
import 'item_name_price_title.dart';
import 'level_two_select_multiple_view.dart';
import 'level_two_select_one_view.dart';
import 'modifier_group_info.dart';

class LevelOneSelectOneView extends StatefulWidget {
  final List<ItemModifier> modifiers;
  final VoidCallback onChanged;

  const LevelOneSelectOneView(
      {Key? key, required this.modifiers, required this.onChanged})
      : super(key: key);

  @override
  State<LevelOneSelectOneView> createState() => _LevelOneSelectOneViewState();
}

class _LevelOneSelectOneViewState extends State<LevelOneSelectOneView> {
  int? _currentModifierId;
  ItemModifier? _currentModifier;

  void _changeCurrentModifier(int? id) {
    setState(() {
      _currentModifierId = id;
    });
    for (var modifier in widget.modifiers) {
      if (modifier.id == id) {
        modifier.isSelected = true;
        modifier.quantity = 1;
        _currentModifier = modifier;
      } else {
        modifier.isSelected = false;
        modifier.quantity = 0;
      }
      _changeLevelTwoModifier(modifier.groups);
    }
    widget.onChanged();
  }

  void _changeLevelTwoModifier(List<ItemModifierGroup> groups) {
    for (var group in groups) {
      for (var modifier in group.modifiers) {
        modifier.isSelected = false;
        modifier.quantity = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSize.s8.rSp),
              bottomRight: Radius.circular(AppSize.s8.rSp),
            ),
            color: AppColors.white,
          ),
          child: Column(
            children: widget.modifiers.map((modifier) {
              return RadioListTile<int>(
                value: modifier.id,
                groupValue: _currentModifierId,
                title: ItemNamePriceTitle(
                    name: modifier.title, prices: modifier.prices),
                onChanged: _changeCurrentModifier,
                selected: _currentModifierId == modifier.id,
                activeColor: AppColors.purpleBlue,
              );
            }).toList(),
          ),
        ),
        if (_currentModifier != null)
          Column(
            children: _currentModifier!.groups.map((group) {
              return Container(
                margin: EdgeInsets.only(top: AppSize.s8.rh),
                child: Column(
                  children: [
                    ModifierGroupInfo(
                        title: '${group.title} for ${_currentModifier!.title}',
                        rule: group.rule),
                    (group.rule.typeTitle == RuleType.exact &&
                            group.rule.value == 1)
                        ? LevelTwoSelectOneView(
                            modifiers: group.modifiers,
                            onChanged: widget.onChanged,
                          )
                        : LevelTwoSelectMultipleView(
                            modifiers: group.modifiers,
                            onChanged: widget.onChanged,
                          ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
