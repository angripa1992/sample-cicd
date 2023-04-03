import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/item_modifier.dart';
import '../../../../domain/entities/item_modifier_group.dart';
import 'item_counter.dart';
import 'item_name_price_title.dart';
import 'level_two_select_multiple_view.dart';
import 'level_two_select_one_view.dart';
import 'modifier_group_info.dart';

class LevelOneSelectMultipleView extends StatefulWidget {
  final List<ItemModifier> modifiers;

  const LevelOneSelectMultipleView({Key? key, required this.modifiers})
      : super(key: key);

  @override
  State<LevelOneSelectMultipleView> createState() =>
      _LevelOneSelectMultipleViewState();
}

class _LevelOneSelectMultipleViewState
    extends State<LevelOneSelectMultipleView> {
  final Map<int, bool> _values = {};
  final Map<int, int> _counter = {};
  final List<ItemModifier> _currentModifierList = [];

  @override
  void initState() {
    for (var element in widget.modifiers) {
      _values[element.id] = element.isSelected;
      _counter[element.id] = element.quantity;
    }
    super.initState();
  }

  void _onChanged(ItemModifier modifier, bool? value) {
    if (value != null) {
      setState(() {
        _values[modifier.id] = value;
        if (value) {
          modifier.isSelected = true;
          _currentModifierList.add(modifier);
        } else {
          modifier.isSelected = false;
          modifier.quantity = 0;
          _currentModifierList
              .removeWhere((element) => element.id == modifier.id);
          _changeLevelTwoModifier(modifier.groups);
        }
      });
    }
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
              bottomRight: Radius.circular(AppSize.s8.rSp),
              bottomLeft: Radius.circular(AppSize.s8.rSp),
            ),
            color: AppColors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: AppSize.s8.rh),
            child: Column(
              children: widget.modifiers.map((modifier) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.purpleBlue,
                      title: ItemNamePriceTitle(
                        name: modifier.title,
                        prices: modifier.prices,
                      ),
                      value: _values[modifier.id],
                      onChanged: (value) {
                        _onChanged(modifier, value);
                      },
                    ),
                    if (_values[modifier.id] == true)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSize.s32.rw),
                        child: ItemCounter(
                          count: modifier.quantity,
                          onChanged: (quantity) {
                            modifier.quantity = quantity;
                          },
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
        Column(
          children: _currentModifierList.map((modifier) {
            return Column(
              children: modifier.groups.map((group) {
                return Container(
                  margin: EdgeInsets.only(top: AppSize.s8.rh),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                    color: AppColors.white,
                  ),
                  child: Column(
                    children: [
                      ModifierGroupInfo(
                        title: '${group.title} for ${modifier.title}',
                        rule: group.rule,
                      ),
                      (group.rule.typeTitle == RuleType.exact && group.rule.value == 1)
                          ? LevelTwoSelectOneView(modifiers: group.modifiers)
                          : LevelTwoSelectMultipleView(
                              modifiers: group.modifiers),
                    ],
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ],
    );
  }
}
