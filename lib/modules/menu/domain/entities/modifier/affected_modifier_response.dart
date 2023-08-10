class AffectedModifierResponse {
  final bool affected;
  final List<DisabledItem> items;

  AffectedModifierResponse({required this.affected, required this.items});
}

class DisabledItem {
  final int itemId;
  final String title;

  DisabledItem({required this.itemId, required this.title});
}
