import '../../data/models/item_status.dart';

class ItemStatus {
  final int providerId;
  final bool enabled;
  final bool hidden;

  ItemStatus({
    required this.providerId,
    required this.enabled,
    required this.hidden,
  });

  ItemStatus copy() => ItemStatus(
        providerId: providerId,
        enabled: enabled,
        hidden: hidden,
      );

  ItemStatusModel toModel() => ItemStatusModel(
        providerId: providerId,
        enabled: enabled,
        hidden: hidden,
      );
}
