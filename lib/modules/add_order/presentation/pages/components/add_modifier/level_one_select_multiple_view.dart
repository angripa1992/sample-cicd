import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/item_modifier.dart';
import '../../../../utils/order_price_provider.dart';
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

  void _onChanged(ItemModifier modifier,bool? value){
    if(value != null){
      setState(() {
        _values[modifier.id] = value;
        if (value) {
          _currentModifierList.add(modifier);
        } else {
          _currentModifierList.removeWhere((element) => element.id == modifier.id);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: widget.modifiers.map((modifier) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: ItemNamePriceTitle(name: modifier.title,prices: modifier.prices),
              value: _values[modifier.id],
              onChanged: (value) {
                _onChanged(modifier,value);
              },
            );
          }).toList(),
        ),
          Column(
            children: _currentModifierList.map((modifier) {
              return Column(
                children: modifier.groups.map((e) {
                  return Container(
                    margin: EdgeInsets.only(top: AppSize.s8.rh),
                    child: Column(
                      children: [
                        ModifierGroupInfo(title: e.title, rule: e.rule),
                        e.rule.value == 1
                            ? LevelTwoSelectOneView(modifiers: e.modifiers)
                            : LevelTwoSelectMultipleView(modifiers: e.modifiers),
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
