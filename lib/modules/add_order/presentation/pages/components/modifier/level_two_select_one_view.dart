import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/item_modifier.dart';
import 'item_name_price_title.dart';

class LevelTwoSelectOneView extends StatefulWidget {
  final List<ItemModifier> modifiers;
  final VoidCallback onChanged;

  const LevelTwoSelectOneView(
      {Key? key, required this.modifiers, required this.onChanged})
      : super(key: key);

  @override
  State<LevelTwoSelectOneView> createState() => _LevelTwoSelectOneViewState();
}

class _LevelTwoSelectOneViewState extends State<LevelTwoSelectOneView> {
  int? _currentModifierId;

  @override
  void initState() {
    super.initState();
    _initModifierSelectedState();
  }

  void _initModifierSelectedState() {
    for (var modifier in widget.modifiers) {
      if (modifier.isSelected) {
        _currentModifierId = modifier.id;
        break;
      }
    }
  }

  void _onChanged(int? id) {
    setState(() {
      _currentModifierId = id;
    });
    for (var element in widget.modifiers) {
      if (element.id == id) {
        element.isSelected = true;
        element.quantity = 1;
      } else {
        element.isSelected = false;
        element.quantity = 0;
      }
    }
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSize.s8.rSp),
          bottomRight: Radius.circular(AppSize.s8.rSp),
        ),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: AppSize.s8.rh),
        child: Column(
          key: UniqueKey(),
          children: widget.modifiers.map((modifier) {
            return RadioListTile<int>(
              value: modifier.id,
              groupValue: _currentModifierId,
              title: ItemNamePriceTitle(
                  name: modifier.title, prices: modifier.prices),
              onChanged: _onChanged,
              selected: _currentModifierId == modifier.id,
              activeColor: AppColors.primary,
            );
          }).toList(),
        ),
      ),
    );
  }
}
