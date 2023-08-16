import '../../../data/models/modifier/item_status_model.dart';

class MenuItemModifierVisibility {
  final int providerId;
  final bool visibility;

  MenuItemModifierVisibility({
    required this.providerId,
    required this.visibility,
  });

  MenuItemModifierVisibility copy() => MenuItemModifierVisibility(
        providerId: providerId,
        visibility: visibility,
      );

  MenuItemStatusModel toModel(bool enabled) => MenuItemStatusModel(
        providerId: providerId,
        enabled: enabled,
        hidden: !visibility,
      );
}
