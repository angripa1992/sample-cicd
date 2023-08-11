import 'package:klikit/app/extensions.dart';

import '../../../domain/entities/modifier/item_visibility.dart';

class AddOrderItemStatusModel {
  int? providerId;
  bool? enabled;
  bool? hidden;

  AddOrderItemStatusModel({this.providerId, this.enabled, this.hidden});

  AddOrderItemStatusModel.fromJson(Map<String, dynamic> json) {
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

  // AddOrderModifierItemStatus toEntity() {
  //   return AddOrderModifierItemStatus(
  //     providerId: providerId.orZero(),
  //     enabled: enabled.orFalse(),
  //     hidden: hidden.orFalse(),
  //   );
  // }

}
