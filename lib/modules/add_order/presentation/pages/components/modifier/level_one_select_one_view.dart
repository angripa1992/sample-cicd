import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier_group.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/modifier/item_modifier.dart';
import 'item_name_price_title.dart';
import 'level_two_select_multiple_view.dart';
import 'level_two_select_one_view.dart';
import 'modifier_group_info.dart';

class LevelOneSelectOneView extends StatefulWidget {
  final List<AddOrderItemModifier> modifiers;
  final VoidCallback onChanged;

  const LevelOneSelectOneView(
      {Key? key, required this.modifiers, required this.onChanged})
      : super(key: key);

  @override
  State<LevelOneSelectOneView> createState() => _LevelOneSelectOneViewState();
}

class _LevelOneSelectOneViewState extends State<LevelOneSelectOneView> {
  int? _currentModifierId;
  AddOrderItemModifier? _currentModifier;

  @override
  void initState() {
    super.initState();
    _initModifierSelectedState();
  }

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

  void _initModifierSelectedState() {
    for (var modifier in widget.modifiers) {
      if (modifier.isSelected) {
        _currentModifierId = modifier.id;
        _currentModifier = modifier;
        break;
      }
    }
  }

  void _changeLevelTwoModifier(List<AddOrderItemModifierGroup> groups) {
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
            key: UniqueKey(),
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
            key: UniqueKey(),
            children: _currentModifier!.groups.map((group) {
              return Container(
                margin: EdgeInsets.only(top: AppSize.s8.rh),
                child: Column(
                  children: [
                    ModifierGroupInfo(
                      title:
                          '${group.title} ${AppStrings.for_.tr()} ${_currentModifier!.title}',
                      rule: group.rule,
                    ),
                    ((group.rule.min == group.rule.max) && group.rule.max == 1)
                        ? LevelTwoSelectOneView(
                            modifiers: group.modifiers,
                            onChanged: widget.onChanged,
                          )
                        : LevelTwoSelectMultipleView(
                            key: UniqueKey(),
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
