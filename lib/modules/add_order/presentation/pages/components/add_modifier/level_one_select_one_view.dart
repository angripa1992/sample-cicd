import 'package:flutter/material.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/styles.dart';
import 'level_two_select_multiple_view.dart';
import 'level_two_select_one_view.dart';
import '../../../../domain/entities/item_modifier.dart';
import '../../../../domain/entities/item_modifier_group.dart';

class LevelOneSelectOneView extends StatefulWidget {
  final List<ItemModifier> modifiers;

  const LevelOneSelectOneView({Key? key, required this.modifiers})
      : super(key: key);

  @override
  State<LevelOneSelectOneView> createState() => _LevelOneSelectOneViewState();
}

class _LevelOneSelectOneViewState extends State<LevelOneSelectOneView> {
  int? _currentModifierId;

  List<ItemModifierGroup> _getGroups() {
    if (_currentModifierId == null) {
      return [];
    }
    return widget.modifiers
        .firstWhere((element) => element.id == _currentModifierId)
        .groups;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: createRadioListUsers(),
        ),
        Column(
          children: _getGroups().map((e) {
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

  List<Widget> createRadioListUsers() {
    List<Widget> widgets = [];
    for (var modifier in widget.modifiers) {
      widgets.add(
        RadioListTile<int>(
          value: modifier.id,
          groupValue: _currentModifierId,
          title: Text(modifier.title),
          onChanged: (id) {
            setState(() {
              _currentModifierId = id;
            });
          },
          selected: _currentModifierId == modifier.id,
          activeColor: Colors.green,
        ),
      );
    }
    return widgets;
  }
}
