import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/domain/entities/modifier_disabled_response.dart';

part 'modifier_disabled_response_model.g.dart';

@JsonSerializable()
class ModifierDisabledResponseModel {
  bool? affected;
  List<DisabledItemModel>? items;

  ModifierDisabledResponseModel({this.affected, this.items});

  factory ModifierDisabledResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ModifierDisabledResponseModelFromJson(json);

  ModifierDisabledResponse toEntity() {
    return ModifierDisabledResponse(
        affected: affected.orFalse(), items: _items());
  }

  List<DisabledItem> _items() {
    List<DisabledItem> itemData = [];
    if (items == null) return itemData;
    for (var element in items!) {
      itemData.add(element.toEntity());
    }
    return itemData;
  }
}

@JsonSerializable()
class DisabledItemModel {
  @JsonKey(name: 'item_id')
  int? itemId;
  String? title;

  DisabledItemModel({this.itemId, this.title});

  factory DisabledItemModel.fromJson(Map<String, dynamic> json) =>
      _$DisabledItemModelFromJson(json);

  DisabledItem toEntity() {
    return DisabledItem(itemId: itemId.orZero(), title: title.orEmpty());
  }
}
