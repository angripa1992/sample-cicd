import 'package:json_annotation/json_annotation.dart';

part 'v2_common_data_model.g.dart';

@JsonSerializable()
class V2TitleModel {
  String? en;
  String? tl;

  V2TitleModel({
    this.en,
    this.tl,
  });

  factory V2TitleModel.fromJson(Map<String, dynamic> json) =>
      _$V2TitleModelFromJson(json);
}

@JsonSerializable()
class V2VisibilityModel {
  int? providerID;
  bool? status;

  V2VisibilityModel({
    this.providerID,
    this.status,
  });

  factory V2VisibilityModel.fromJson(Map<String, dynamic> json) =>
      _$V2VisibilityModelFromJson(json);
}

@JsonSerializable()
class V2PriceModel {
  int? providerID;
  List<V2PriceDetailsModel>? details;

  V2PriceModel({
    this.providerID,
    this.details,
  });

  factory V2PriceModel.fromJson(Map<String, dynamic> json) =>
      _$V2PriceModelFromJson(json);
}

@JsonSerializable()
class V2PriceDetailsModel {
  String? currencyCode;
  num? price;
  num? takeAwayPrice;

  V2PriceDetailsModel({
    this.currencyCode,
    this.price,
    this.takeAwayPrice,
  });

  factory V2PriceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$V2PriceDetailsModelFromJson(json);
}

@JsonSerializable()
class V2ResourcesModel {
  int? providerID;
  String? type;
  List<V2ResourcePathsModel>? paths;

  V2ResourcesModel({
    this.providerID,
    this.type,
    this.paths,
  });

  factory V2ResourcesModel.fromJson(Map<String, dynamic> json) =>
      _$V2ResourcesModelFromJson(json);
}

@JsonSerializable()
class V2ResourcePathsModel {
  String? path;
  int? sequence;
  @JsonKey(name: 'default')
  bool? byDefault;

  V2ResourcePathsModel({
    this.path,
    this.sequence,
    this.byDefault,
  });

  factory V2ResourcePathsModel.fromJson(Map<String, dynamic> json) =>
      _$V2ResourcePathsModelFromJson(json);
}

@JsonSerializable()
class V2OosModel {
  bool? available;
  V2SnoozeModel? snooze;

  V2OosModel({
    this.available,
    this.snooze,
  });

  factory V2OosModel.fromJson(Map<String, dynamic> json) =>
      _$V2OosModelFromJson(json);
}

@JsonSerializable()
class V2SnoozeModel {
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  int? duration;
  String? unit;

  V2SnoozeModel({
    this.startTime,
    this.endTime,
    this.duration,
    this.unit,
  });

  factory V2SnoozeModel.fromJson(Map<String, dynamic> json) =>
      _$V2SnoozeModelFromJson(json);
}
