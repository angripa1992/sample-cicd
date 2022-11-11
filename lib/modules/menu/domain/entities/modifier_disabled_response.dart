class ModifierDisabledResponse {
  final bool affected;
  final List<DisabledItem> items;

  ModifierDisabledResponse({required this.affected, required this.items});
}

class DisabledItem {
  final int itemId;
  final String title;

  DisabledItem({required this.itemId, required this.title});
}
