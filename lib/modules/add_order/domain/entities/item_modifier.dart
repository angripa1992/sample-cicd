import 'item_modifier_group.dart';
import 'item_price.dart';
import 'item_status.dart';

class ItemModifier {
  final int id;
  final int modifierId;
  final int immgId;
  final String title;
  final int sequence;
  final List<ItemStatus> statuses;
  final List<ItemPrice> prices;
  final List<ItemModifierGroup> groups;
  bool isSelected;
  int  quantity;

  ItemModifier({
    required this.id,
    required this.modifierId,
    required this.immgId,
    required this.title,
    required this.sequence,
    required this.statuses,
    required this.prices,
    required this.groups,
    this.isSelected = false,
    this.quantity = 0,
  });
}
