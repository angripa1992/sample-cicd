class GrabOrderUpdateRequestModel {
  final int id;
  final String externalId;
  final List<GrabItem> items;

  GrabOrderUpdateRequestModel({
    required this.id,
    required this.externalId,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['external_id'] = externalId;
    data['items'] = items.map((v) => v.toJson()).toList();
    return data;
  }
}

class GrabItem {
  final String id;
  final String externalId;
  final int quantity;
  final String status;
  final num unitPrice;

  GrabItem({
    required this.id,
    required this.externalId,
    required this.quantity,
    required this.status,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['external_id'] = externalId;
    data['quantity'] = quantity;
    data['status'] = status;
    data['unit_price'] = unitPrice;
    return data;
  }
}
