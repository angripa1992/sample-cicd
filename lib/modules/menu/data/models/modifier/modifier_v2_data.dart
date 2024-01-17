import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/modules/menu/data/models/v2_common_data_model.dart';

part 'modifier_v2_data.g.dart';

@JsonSerializable()
class V2ModifierGroupModel {
  int? id;
  int? businessID;
  V2TitleModel? title;
  V2TitleModel? description;
  List<V2VisibilityModel>? visibilities;
  bool? isEnabled;
  List<V2GroupedModifiersModel>? groupedModifiers;

  V2ModifierGroupModel({
    this.id,
    this.businessID,
    this.title,
    this.description,
    this.visibilities,
    this.isEnabled,
    this.groupedModifiers,
  });

  factory V2ModifierGroupModel.fromJson(Map<String, dynamic> json) => _$V2ModifierGroupModelFromJson(json);
}

@JsonSerializable()
class V2GroupedModifiersModel {
  int? id;
  V2TitleModel? title;
  V2TitleModel? description;
  List<V2VisibilityModel>? visibilities;
  List<V2PriceModel>? prices;
  bool? isEnabled;
  int? sequence;

  V2GroupedModifiersModel({
    this.id,
    this.title,
    this.description,
    this.visibilities,
    this.isEnabled,
    this.sequence,
    this.prices,
  });

  factory V2GroupedModifiersModel.fromJson(Map<String, dynamic> json) => _$V2GroupedModifiersModelFromJson(json);
}
