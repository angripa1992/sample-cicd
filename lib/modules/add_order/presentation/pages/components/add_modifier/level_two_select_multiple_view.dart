import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/item_modifier.dart';
import 'item_counter.dart';
import 'item_name_price_title.dart';

class LevelTwoSelectMultipleView extends StatefulWidget {
  final List<ItemModifier> modifiers;
  final VoidCallback onChanged;

  const LevelTwoSelectMultipleView({Key? key, required this.modifiers, required this.onChanged})
      : super(key: key);

  @override
  State<LevelTwoSelectMultipleView> createState() =>
      _LevelTwoSelectMultipleViewState();
}

class _LevelTwoSelectMultipleViewState
    extends State<LevelTwoSelectMultipleView> {
  final Map<int, bool> _values = {};
  final Map<int, int> _counter = {};

  @override
  void initState() {
    for (var element in widget.modifiers) {
      _values[element.id] = element.isSelected;
      _counter[element.id] = element.quantity ;
    }
    super.initState();
  }

  void _onChanged(ItemModifier modifier, bool? value) {
    if (value != null) {
      setState(() {
        _values[modifier.id] = value;
      });
      if (!value) {
        modifier.isSelected = false;
        modifier.quantity = 0;
      }else{
        modifier.isSelected = true;
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
                  onChanged: (value) => _onChanged(modifier, value),
                ),
                if (_values[modifier.id] == true)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s32.rw),
                    child: ItemCounter(
                      count: modifier.quantity,
                      onChanged: (quantity) {
                        modifier.quantity = quantity;
                        widget.onChanged();
                      },
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
