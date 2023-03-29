import 'package:flutter/material.dart';

import '../../../../domain/entities/item_modifier.dart';


class LevelTwoSelectOneView extends StatefulWidget {
  final List<ItemModifier> modifiers;

  const LevelTwoSelectOneView({Key? key, required this.modifiers})
      : super(key: key);

  @override
  State<LevelTwoSelectOneView> createState() => _LevelTwoSelectOneViewState();
}

class _LevelTwoSelectOneViewState extends State<LevelTwoSelectOneView> {
  int? _currentModifierId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: createRadioListUsers(),
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
