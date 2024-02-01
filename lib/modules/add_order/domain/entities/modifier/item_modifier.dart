import 'package:collection/collection.dart';

import '../../../../../app/constants.dart';
import 'item_modifier_group.dart';
import 'item_price.dart';
import 'item_visibility.dart';

class MenuItemModifier {
  final int id;
  final int modifierId;
  final int modifierGroupId;
  final String modifierGroupName;
  final int immgId;
  final String skuID;
  final String title;
  final int sequence;
  final bool enabled;
  final List<MenuItemModifierVisibility> visibilities;
  final List<MenuItemModifierPrice> prices;
  final List<MenuItemModifierGroup> groups;
  bool isSelected;
  int quantity;

  MenuItemModifier({
    required this.id,
    required this.modifierId,
    required this.modifierGroupId,
    required this.modifierGroupName,
    required this.immgId,
    required this.skuID,
    required this.title,
    required this.sequence,
    required this.enabled,
    required this.visibilities,
    required this.prices,
    required this.groups,
    this.isSelected = false,
    this.quantity = 0,
  });

  MenuItemModifier copy() => MenuItemModifier(
        id: id,
        modifierId: modifierId,
        modifierGroupId: modifierGroupId,
        modifierGroupName: modifierGroupName,
        immgId: immgId,
        skuID: skuID,
        title: title,
        sequence: sequence,
        enabled: enabled,
        visibilities: visibilities.map((e) => e.copy()).toList(),
        prices: prices.map((e) => e.copy()).toList(),
        groups: groups.map((e) => e.copy()).toList(),
        isSelected: isSelected,
        quantity: quantity,
      );

  MenuItemModifierPrice klikitPrice() => prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);

  bool visible() {
    if (visibilities.isEmpty) return true;
    final itemVisibility = visibilities.firstWhereOrNull((element) => element.providerId == ProviderID.KLIKIT);
    return itemVisibility?.visibility ?? true;
  }
}
