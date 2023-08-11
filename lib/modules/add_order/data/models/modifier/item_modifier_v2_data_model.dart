import 'package:json_annotation/json_annotation.dart';

import '../../../../menu/data/models/v2_common_data_model.dart';

part 'item_modifier_v2_data_model.g.dart';

@JsonSerializable()
class V2ItemModifierGroupModel {
  int? id;
  V2TitleModel? title;
  V2TitleModel? description;
  int? sequence;
  bool? enabled;
  int? min;
  int? max;
  List<V2VisibilityModel>? visibilities;
  List<V2ItemModifierModel>? modifiers;

  V2ItemModifierGroupModel({
    this.id,
    this.title,
    this.description,
    this.sequence,
    this.enabled,
    this.min,
    this.max,
    this.visibilities,
    this.modifiers,
  });

  factory V2ItemModifierGroupModel.fromJson(Map<String, dynamic> json) =>
      _$V2ItemModifierGroupModelFromJson(json);
}

@JsonSerializable()
class V2ItemModifierModel {
  int? id;
  V2TitleModel? title;
  V2TitleModel? description;
  num? vat;
  bool? enabled;
  List<V2VisibilityModel>? visibilities;
  List<V2PriceModel>? prices;
  bool? isCustomPrice;
  bool? itemIsEnabled;
  List<V2ResourcesModel>? resources;
  int? maxQuantityPerDay;
  V2OosModel? oos;
  List<V2ItemModifierGroupModel>? groups;

  V2ItemModifierModel({
    this.id,
    this.title,
    this.description,
    this.vat,
    this.enabled,
    this.visibilities,
    this.prices,
    this.isCustomPrice,
    this.itemIsEnabled,
    this.resources,
    this.maxQuantityPerDay,
    this.oos,
    this.groups,
  });

  factory V2ItemModifierModel.fromJson(Map<String, dynamic> json) =>
      _$V2ItemModifierModelFromJson(json);
}
