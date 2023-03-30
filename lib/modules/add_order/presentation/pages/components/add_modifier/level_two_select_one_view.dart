import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/styles.dart';
import '../../../../domain/entities/item_modifier.dart';
import '../../../../utils/order_price_provider.dart';
import 'item_name_price_title.dart';


class LevelTwoSelectOneView extends StatefulWidget {
  final List<ItemModifier> modifiers;

  const LevelTwoSelectOneView({Key? key, required this.modifiers})
      : super(key: key);

  @override
  State<LevelTwoSelectOneView> createState() => _LevelTwoSelectOneViewState();
}

class _LevelTwoSelectOneViewState extends State<LevelTwoSelectOneView> {
  int? _currentModifierId;

  void _onChanged(int? id){
    setState(() {
      _currentModifierId = id;
    });
    for (var element in widget.modifiers) {
      if(element.id == id){
        element.isSelected = true;
        element.quantity = 1;
      }else{
        element.isSelected = false;
        element.quantity = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.modifiers.map((modifier) {
        return  RadioListTile<int>(
          value: modifier.id,
          groupValue: _currentModifierId,
          title: ItemNamePriceTitle(name: modifier.title,prices: modifier.prices),
          onChanged: _onChanged,
          selected: _currentModifierId == modifier.id,
          activeColor: AppColors.purpleBlue,
        );
      }).toList(),
    );
  }
}
