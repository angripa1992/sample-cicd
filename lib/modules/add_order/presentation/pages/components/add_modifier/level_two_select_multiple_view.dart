import 'package:flutter/material.dart';

import '../../../../domain/entities/item_modifier.dart';

class LevelTwoSelectMultipleView extends StatefulWidget {
  final List<ItemModifier> modifiers;

  const LevelTwoSelectMultipleView({Key? key, required this.modifiers})
      : super(key: key);

  @override
  State<LevelTwoSelectMultipleView> createState() =>
      _LevelTwoSelectMultipleViewState();
}

class _LevelTwoSelectMultipleViewState extends State<LevelTwoSelectMultipleView> {
  final Map<int, bool> _values = {};
  final Map<int, int> _counter = {};

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
      children: widget.modifiers.map((e) {
        return CheckboxListTile(
          title: Text(e.title),
          value: _values[e.id],
          onChanged: (value) {
            setState(() {
              _values[e.id] = value!;
            });
          },
        );
      }).toList(),
    );
  }
}
