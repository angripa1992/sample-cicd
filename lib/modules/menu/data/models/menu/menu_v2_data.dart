import 'package:json_annotation/json_annotation.dart';

part 'menu_v2_data.g.dart';

@JsonSerializable()
class MenuV1DataModel {
  MenuV2BranchInfo? branchInfo;
  List<MenuV2Sections>? sections;

  MenuV1DataModel({
    this.branchInfo,
    this.sections,
  });

  factory MenuV1DataModel.fromJson(Map<String, dynamic> json) => _$MenuV1DataModelFromJson(json);
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
  });

  factory MenuV2BranchInfo.fromJson(Map<String, dynamic> json) => _$MenuV2BranchInfoFromJson(json);
}

@JsonSerializable()
class MenuV2Sections {
  int? id;
  MenuV2Title? title;
  MenuV2Title? description;
  MenuV2AvailableTimesModel? availableTimes;
  bool? isAvailable;
  bool? enabled;
  List<MenuV2Visibility>? visibilities;
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

  factory MenuV2Sections.fromJson(Map<String, dynamic> json) => _$MenuV2SectionsFromJson(json);
}

@JsonSerializable()
class MenuV2Title {
  String? en;
  String? tl;

  MenuV2Title({
    this.en,
    this.tl,
  });

  factory MenuV2Title.fromJson(Map<String, dynamic> json) => _$MenuV2TitleFromJson(json);
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

  factory MenuV2AvailableTimesModel.fromJson(Map<String, dynamic> json) => _$MenuV2AvailableTimesModelFromJson(json);
}

@JsonSerializable()
class MenuV2DayInfoModel {
  bool? disabled;
  List<MenuV2SlotsModel>? slots;

  MenuV2DayInfoModel({
    this.disabled,
    this.slots,
  });

  factory MenuV2DayInfoModel.fromJson(Map<String, dynamic> json) => _$MenuV2DayInfoModelFromJson(json);
}

@JsonSerializable()
class MenuV2SlotsModel {
  int? startTime;
  int? endTime;

  MenuV2SlotsModel({
    this.startTime,
    this.endTime,
  });

  factory MenuV2SlotsModel.fromJson(Map<String, dynamic> json) => _$MenuV2SlotsModelFromJson(json);
}

@JsonSerializable()
class MenuV2Visibility {
  int? providerID;
  bool? status;

  MenuV2Visibility({
    this.providerID,
    this.status,
  });

  factory MenuV2Visibility.fromJson(Map<String, dynamic> json) => _$MenuV2VisibilityFromJson(json);
}

@JsonSerializable()
class MenuV2Category {
  int? id;
  MenuV2Title? title;
  MenuV2Title? description;
  bool? enabled;
  bool? alcBeverages;
  List<MenuV2Visibility>? visibilities;
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

  factory MenuV2Category.fromJson(Map<String, dynamic> json) => _$MenuV2CategoryFromJson(json);
}

@JsonSerializable()
class MenuV2CategoryItem {
  int? id;
  MenuV2Title? title;
  MenuV2Title? description;
  int? vat;
  bool? enabled;
  List<MenuV2Visibility>? visibilities;
  List<MenuV2Price>? prices;
  bool? itemIsEnabled;
  List<MenuV2Resources>? resources;
  int? sequence;
  MenuV2Oos? oos;

  MenuV2CategoryItem({
    this.id,
    this.title,
    this.description,
    this.vat,
    this.enabled,
    this.visibilities,
    this.prices,
    this.itemIsEnabled,
    this.resources,
    this.sequence,
    this.oos,
  });

  factory MenuV2CategoryItem.fromJson(Map<String, dynamic> json) => _$MenuV2CategoryItemFromJson(json);
}

@JsonSerializable()
class MenuV2Price {
  int? providerID;
  List<MenuV2PriceDetails>? details;

  MenuV2Price({
    this.providerID,
    this.details,
  });

  factory MenuV2Price.fromJson(Map<String, dynamic> json) => _$MenuV2PriceFromJson(json);
}

@JsonSerializable()
class MenuV2PriceDetails {
  String? currencyCode;
  int? price;
  int? takeAwayPrice;

  MenuV2PriceDetails({
    this.currencyCode,
    this.price,
    this.takeAwayPrice,
  });

  factory MenuV2PriceDetails.fromJson(Map<String, dynamic> json) => _$MenuV2PriceDetailsFromJson(json);
}

@JsonSerializable()
class MenuV2Resources {
  int? providerID;
  String? type;
  List<MenuV2ResourcePaths>? paths;

  MenuV2Resources({
    this.providerID,
    this.type,
    this.paths,
  });

  factory MenuV2Resources.fromJson(Map<String, dynamic> json) => _$MenuV2ResourcesFromJson(json);
}

@JsonSerializable()
class MenuV2ResourcePaths {
  String? path;
  int? sequence;
  @JsonKey(name: 'default')
  bool? byDefault;

  MenuV2ResourcePaths({this.path, this.sequence, this.byDefault,});

  factory MenuV2ResourcePaths.fromJson(Map<String, dynamic> json) => _$MenuV2ResourcePathsFromJson(json);
}

@JsonSerializable()
class MenuV2Oos {
  bool? available;
  MenuV2Snooze? snooze;

  MenuV2Oos({
    this.available,
    this.snooze,
  });

  factory MenuV2Oos.fromJson(Map<String, dynamic> json) => _$MenuV2OosFromJson(json);
}

@JsonSerializable()
class MenuV2Snooze {
  String? endTime;
  int? duration;

  MenuV2Snooze({
    this.endTime,
    this.duration,
  });

  factory MenuV2Snooze.fromJson(Map<String, dynamic> json) => _$MenuV2SnoozeFromJson(json);
}
