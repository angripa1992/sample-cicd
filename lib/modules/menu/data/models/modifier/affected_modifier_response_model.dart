import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/domain/entities/modifier/affected_modifier_response.dart';

part 'affected_modifier_response_model.g.dart';

@JsonSerializable()
class AffectedModifierResponseModel {
  bool? affected;
  List<DisabledItemResponseModel>? items;

  AffectedModifierResponseModel({this.affected, this.items});

  factory AffectedModifierResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AffectedModifierResponseModelFromJson(json);

  AffectedModifierResponse toEntity() {
    return AffectedModifierResponse(
      affected: affected.orFalse(),
      items: items?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

@JsonSerializable()
class DisabledItemResponseModel {
  @JsonKey(name: 'item_id')
  int? itemId;
  String? title;

  DisabledItemResponseModel({this.itemId, this.title});

  factory DisabledItemResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DisabledItemResponseModelFromJson(json);

  DisabledItem toEntity() {
    return DisabledItem(itemId: itemId.orZero(), title: title.orEmpty());
  }
}
