import 'package:json_annotation/json_annotation.dart';

import '../v2_common_data_model.dart';

part 'menu_v2_data.g.dart';

@JsonSerializable()
class MenuV2DataModel {
  MenuV2BranchInfo? branchInfo;
  List<MenuV2Sections>? sections;

  MenuV2DataModel({
    this.branchInfo,
    this.sections,
  });

  factory MenuV2DataModel.fromJson(Map<String, dynamic> json) =>
      _$MenuV2DataModelFromJson(json);
}

@JsonSerializable()
class MenuV2BranchInfo {
  int? businessID;
  int? brandID;
  int? branchID;
  int? countryID;
  int? currencyID;
  int? startTime;
  int? endTime;
  int? availabilityMask;
  String? providerIDs;
  String? languageCode;
  String? currencyCode;
  String? currencySymbol;

  MenuV2BranchInfo({
    this.businessID,
    this.brandID,
    this.branchID,
    this.countryID,
    this.currencyID,
    this.startTime,
    this.endTime,
    this.availabilityMask,
    this.providerIDs,
    this.languageCode,
    this.currencyCode,
    this.currencySymbol,
  });

  factory MenuV2BranchInfo.fromJson(Map<String, dynamic> json) =>
      _$MenuV2BranchInfoFromJson(json);
}

@JsonSerializable()
class MenuV2Sections {
  int? id;
  V2TitleModel? title;
  V2TitleModel? description;
  MenuV2AvailableTimesModel? availableTimes;
  bool? isAvailable;
  bool? enabled;
  List<V2VisibilityModel>? visibilities;
  int? sequence;
  List<MenuV2Category>? categories;

  MenuV2Sections({
    this.id,
    this.title,
    this.description,
    this.availableTimes,
    this.isAvailable,
    this.enabled,
    this.visibilities,
    this.sequence,
    this.categories,
  });

  factory MenuV2Sections.fromJson(Map<String, dynamic> json) =>
      _$MenuV2SectionsFromJson(json);
}

@JsonSerializable()
class MenuV2AvailableTimesModel {
  @JsonKey(name: '0')
  MenuV2DayInfoModel? sunday;
  @JsonKey(name: '1')
  MenuV2DayInfoModel? monday;
  @JsonKey(name: '2')
  MenuV2DayInfoModel? tuesday;
  @JsonKey(name: '3')
  MenuV2DayInfoModel? wednesday;
  @JsonKey(name: '4')
  MenuV2DayInfoModel? thursday;
  @JsonKey(name: '5')
  MenuV2DayInfoModel? friday;
  @JsonKey(name: '6')
  MenuV2DayInfoModel? saturday;

  MenuV2AvailableTimesModel({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory MenuV2AvailableTimesModel.fromJson(Map<String, dynamic> json) =>
      _$MenuV2AvailableTimesModelFromJson(json);
}

@JsonSerializable()
class MenuV2DayInfoModel {
  bool? disabled;
  List<MenuV2SlotsModel>? slots;

  MenuV2DayInfoModel({
    this.disabled,
    this.slots,
  });

  factory MenuV2DayInfoModel.fromJson(Map<String, dynamic> json) =>
      _$MenuV2DayInfoModelFromJson(json);
}

@JsonSerializable()
class MenuV2SlotsModel {
  int? startTime;
  int? endTime;

  MenuV2SlotsModel({
    this.startTime,
    this.endTime,
  });

  factory MenuV2SlotsModel.fromJson(Map<String, dynamic> json) =>
      _$MenuV2SlotsModelFromJson(json);
}

@JsonSerializable()
class MenuV2Category {
  int? id;
  V2TitleModel? title;
  V2TitleModel? description;
  bool? enabled;
  bool? alcBeverages;
  List<V2VisibilityModel>? visibilities;
  int? sequence;
  List<MenuV2CategoryItem>? items;

  MenuV2Category({
    this.id,
    this.title,
    this.description,
    this.enabled,
    this.alcBeverages,
    this.visibilities,
    this.sequence,
    this.items,
  });

  factory MenuV2Category.fromJson(Map<String, dynamic> json) =>
      _$MenuV2CategoryFromJson(json);
}

@JsonSerializable()
class MenuV2CategoryItem {
  int? id;
  V2TitleModel? title;
  V2TitleModel? description;
  int? vat;
  String? skuID;
  bool? enabled;
  List<V2VisibilityModel>? visibilities;
  List<V2PriceModel>? prices;
  bool? itemIsEnabled;
  List<V2ResourcesModel>? resources;
  int? sequence;
  V2OosModel? oos;

  MenuV2CategoryItem({
    this.id,
    this.title,
    this.description,
    this.vat,
    this.skuID,
    this.enabled,
    this.visibilities,
    this.prices,
    this.itemIsEnabled,
    this.resources,
    this.sequence,
    this.oos,
  });

  factory MenuV2CategoryItem.fromJson(Map<String, dynamic> json) =>
      _$MenuV2CategoryItemFromJson(json);
}
