import 'package:json_annotation/json_annotation.dart';

part 'modifier_v1_data.g.dart';

@JsonSerializable()
class V1ModifierGroupModel {
  @JsonKey(name: 'group_id')
  int? groupId;
  String? title;
  bool? defaultData;
  List<V1StatusesModel>? statuses;
  List<V1GroupedModifierItemModel>? modifiers;

  V1ModifierGroupModel({
    this.groupId,
    this.title,
    this.defaultData,
    this.statuses,
    this.modifiers,
  });

  factory V1ModifierGroupModel.fromJson(Map<String, dynamic> json) =>
      _$V1ModifierGroupModelFromJson(json);
}

@JsonSerializable()
class V1GroupedModifierItemModel {
  @JsonKey(name: 'modifier_id')
  int? modifierId;
  String? title;
  int? sequence;
  bool? defaultData;
  List<V1ModifierPricesModel>? prices;
  List<V1StatusesModel>? statuses;
  dynamic meta;

  V1GroupedModifierItemModel({
    this.modifierId,
    this.title,
    this.sequence,
    this.defaultData,
    this.prices,
    this.statuses,
    this.meta,
  });

  factory V1GroupedModifierItemModel.fromJson(Map<String, dynamic> json) =>
      _$V1GroupedModifierItemModelFromJson(json);
}

@JsonSerializable()
class V1StatusesModel {
  @JsonKey(name: 'provider_id')
  int? providerId;
  bool? hidden;
  bool? enabled;

  V1StatusesModel({
    this.providerId,
    this.hidden,
    this.enabled,
  });

  factory V1StatusesModel.fromJson(Map<String, dynamic> json) =>
      _$V1StatusesModelFromJson(json);
}

@JsonSerializable()
class V1ModifierPricesModel {
  @JsonKey(name: 'provider_id')
  int? providerId;
  @JsonKey(name: 'currency_id')
  int? currencyId;
  String? code;
  String? symbol;
  double? price;

  V1ModifierPricesModel({
    this.providerId,
    this.currencyId,
    this.code,
    this.symbol,
    this.price,
  });

  factory V1ModifierPricesModel.fromJson(Map<String, dynamic> json) =>
      _$V1ModifierPricesModelFromJson(json);
}