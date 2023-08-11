import '../../../data/models/modifier/item_status_model.dart';

class AddOrderModifierItemVisibility {
  final int providerId;
  final bool visibility;

  AddOrderModifierItemVisibility({
    required this.providerId,
    required this.visibility,
  });

  AddOrderModifierItemVisibility copy() => AddOrderModifierItemVisibility(
        providerId: providerId,
        visibility: visibility,
      );

  AddOrderItemStatusModel toModel(bool enabled) => AddOrderItemStatusModel(
        providerId: providerId,
        enabled: enabled,
        hidden: !visibility,
      );
}
