import 'package:klikit/app/extensions.dart';

import '../../domain/entities/item_status.dart';

class ItemStatusModel {
  int? providerId;
  bool? enabled;
  bool? hidden;

  ItemStatusModel({this.providerId, this.enabled, this.hidden});

  ItemStatusModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    enabled = json['enabled'];
    hidden = json['hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['provider_id'] = providerId;
    data['enabled'] = enabled;
    data['hidden'] = hidden;
    return data;
  }

  ItemStatus toEntity() {
    return ItemStatus(
      providerId: providerId.orZero(),
      enabled: enabled.orFalse(),
      hidden: hidden.orFalse(),
    );
  }
}
