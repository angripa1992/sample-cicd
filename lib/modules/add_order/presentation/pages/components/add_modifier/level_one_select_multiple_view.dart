import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/styles.dart';
import '../../../../domain/entities/item_modifier.dart';
import 'level_two_select_multiple_view.dart';

class LevelOneSelectMultipleView extends StatefulWidget {
  final List<ItemModifier> modifiers;

  const LevelOneSelectMultipleView({Key? key, required this.modifiers})
      : super(key: key);

  @override
  State<LevelOneSelectMultipleView> createState() =>
      _LevelOneSelectMultipleViewState();
}

class _LevelOneSelectMultipleViewState extends State<LevelOneSelectMultipleView> {
  final Map<int, bool> _values = {};
  final Map<int, int> _counter = {};
  ItemModifier? _currentModifier;

  @override
  void initState() {
    for (var element in widget.modifiers) {
      _values[element.id] = false;
      _counter[element.id] = 0;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: widget.modifiers.map((e) {
            return CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(e.title),
              value: _values[e.id],
              onChanged: (value) {
                setState(() {
                  _values[e.id] = value!;
                  if(value){
                    _currentModifier = e;
                  }else{
                    _currentModifier = null;
                  }
                });
              },
            );
          }).toList(),
        ),
        if(_currentModifier != null)
          Column(
            children: _currentModifier!.groups.map((e) {
              return Column(
                children: [
                  Text(
                    e.title,
                    style: getBoldTextStyle(color: AppColors.red),
                  ),
                  LevelTwoSelectMultipleView(modifiers: e.modifiers),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}
