import '../../../../../app/constants.dart';
import 'item_modifier_group.dart';
import 'item_price.dart';
import 'item_visibility.dart';

class AddOrderItemModifier {
  final int id;
  final int modifierId;
  final int immgId;
  final String title;
  final int sequence;
  final bool enabled;
  final List<AddOrderModifierItemVisibility> visibilities;
  final List<AddOrderModifierItemPrice> prices;
  final List<AddOrderItemModifierGroup> groups;
  bool isSelected;
  int quantity;

  AddOrderItemModifier({
    required this.id,
    required this.modifierId,
    required this.immgId,
    required this.title,
    required this.sequence,
    required this.enabled,
    required this.visibilities,
    required this.prices,
    required this.groups,
    this.isSelected = false,
    this.quantity = 0,
  });

  AddOrderItemModifier copy() => AddOrderItemModifier(
        id: id,
        modifierId: modifierId,
        immgId: immgId,
        title: title,
        sequence: sequence,
        enabled: enabled,
        visibilities: visibilities.map((e) => e.copy()).toList(),
        prices: prices.map((e) => e.copy()).toList(),
        groups: groups.map((e) => e.copy()).toList(),
        isSelected: isSelected,
        quantity: quantity,
      );

  AddOrderModifierItemPrice klikitPrice() =>
      prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);
}
