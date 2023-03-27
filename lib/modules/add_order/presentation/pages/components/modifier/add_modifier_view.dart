import 'package:flutter/material.dart';

import '../../../../../menu/domain/entities/items.dart';
import '../../../../domain/entities/item_modifier_group.dart';
import 'item_description_view.dart';
import 'modifier_header_view.dart';

class AddModifierView extends StatelessWidget {
  final List<ItemModifierGroup> groups;
  final MenuItems item;
  final VoidCallback onClose;

  const AddModifierView(
      {Key? key,
      required this.groups,
      required this.item,
      required this.onClose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModifierHeaderView(
          onBack: onClose,
          itemName: item.title,
        ),
        ItemDescriptionView(item: item),
      ],
    );
  }
}
