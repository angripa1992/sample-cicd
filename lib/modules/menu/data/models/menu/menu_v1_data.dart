import 'package:json_annotation/json_annotation.dart';

part 'menu_v1_data.g.dart';

@JsonSerializable()
class MenuV1MenusDataModel {
  List<MenuV1SectionsModel>? sections;
  @JsonKey(name: 'branch_info')
  MenuV1BranchInfo? branchInfo;

  MenuV1MenusDataModel({
    this.sections,
    this.branchInfo,
  });
  factory MenuV1MenusDataModel.fromJson(Map<String, dynamic> json) => _$MenuV1MenusDataModelFromJson(json);
}

@JsonSerializable()
class MenuV1BranchInfo {
  @JsonKey(name: 'branch_id')
  int? branchId;
  @JsonKey(name: 'country_id')
  int? countryId;
  @JsonKey(name: 'currency_id')
  int? currencyId;
  @JsonKey(name: 'start_time')
  int? startTime;
  @JsonKey(name: 'end_time')
  int? endTime;
  @JsonKey(name: 'availability_mask')
  int? availabilityMask;
  @JsonKey(name: 'provider_ids')
  String? providerIds;
  @JsonKey(name: 'language_code')
  String? languageCode;

  MenuV1BranchInfo({
    this.branchId,
    this.countryId,
    this.currencyId,
    this.startTime,
    this.endTime,
    this.availabilityMask,
    this.providerIds,
    this.languageCode,
  });

  factory MenuV1BranchInfo.fromJson(Map<String, dynamic> json) => _$MenuV1BranchInfoFromJson(json);
}

@JsonSerializable()
class MenuV1AvailableTimesModel {
  @JsonKey(name: '0')
  MenuV1DayInfoModel? sunday;
  @JsonKey(name: '1')
  MenuV1DayInfoModel? monday;
  @JsonKey(name: '2')
  MenuV1DayInfoModel? tuesday;
  @JsonKey(name: '3')
  MenuV1DayInfoModel? wednesday;
  @JsonKey(name: '4')
  MenuV1DayInfoModel? thursday;
  @JsonKey(name: '5')
  MenuV1DayInfoModel? friday;
  @JsonKey(name: '6')
  MenuV1DayInfoModel? saturday;

  MenuV1AvailableTimesModel({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory MenuV1AvailableTimesModel.fromJson(Map<String, dynamic> json) => _$MenuV1AvailableTimesModelFromJson(json);
}

@JsonSerializable()
class MenuV1DayInfoModel {
  bool? disabled;
  List<MenuV1SlotsModel>? slots;

  MenuV1DayInfoModel({
    this.disabled,
    this.slots,
  });

  factory MenuV1DayInfoModel.fromJson(Map<String, dynamic> json) => _$MenuV1DayInfoModelFromJson(json);
}

@JsonSerializable()
class MenuV1SlotsModel {
  @JsonKey(name: 'start_time')
  int? startTime;
  @JsonKey(name: 'end_time')
  int? endTime;

  MenuV1SlotsModel({
    this.startTime,
    this.endTime,
  });

  factory MenuV1SlotsModel.fromJson(Map<String, dynamic> json) => _$MenuV1SlotsModelFromJson(json);
}

@JsonSerializable()
class MenuV1StatusesModel {
  @JsonKey(name: 'provider_id')
  int? providerId;
  bool? hidden;
  bool? enabled;

  MenuV1StatusesModel({
    this.providerId,
    this.hidden,
    this.enabled,
  });

  factory MenuV1StatusesModel.fromJson(Map<String, dynamic> json) => _$MenuV1StatusesModelFromJson(json);
}

@JsonSerializable()
class MenuV1PricesModel {
  @JsonKey(name: 'provider_id')
  int? providerId;
  @JsonKey(name: 'currency_id')
  int? currencyId;
  String? code;
  String? symbol;
  double? price;

  MenuV1PricesModel({
    this.providerId,
    this.currencyId,
    this.code,
    this.symbol,
    this.price,
  });

  factory MenuV1PricesModel.fromJson(Map<String, dynamic> json) => _$MenuV1PricesModelFromJson(json);
}

@JsonSerializable()
class MenuV1StockModel {
  bool? available;
  MenuV1SnoozeModel? snooze;

  MenuV1StockModel({
    this.available,
    this.snooze,
  });

  factory MenuV1StockModel.fromJson(Map<String, dynamic> json) => _$MenuV1StockModelFromJson(json);
}

@JsonSerializable()
class MenuV1SnoozeModel {
  @JsonKey(name: 'end_time')
  String? endTime;
  int? duration;

  MenuV1SnoozeModel({
    this.endTime,
    this.duration,
  });

  factory MenuV1SnoozeModel.fromJson(Map<String, dynamic> json) => _$MenuV1SnoozeModelFromJson(json);
}

@JsonSerializable()
class MenuV1ItemsModel {
  int? id;
  String? title;
  List<MenuV1PricesModel>? prices;
  int? vat;
  String? description;
  String? image;
  bool? enabled;
  bool? hidden;
  List<MenuV1StatusesModel>? statuses;
  int? sequence;
  MenuV1StockModel? stock;
  @JsonKey(name: 'default_item_id')
  int? defaultItemId;
  @JsonKey(name: 'sku_id')
  String? skuID;

  MenuV1ItemsModel({
    this.id,
    this.title,
    this.prices,
    this.vat,
    this.description,
    this.image,
    this.enabled,
    this.hidden,
    this.statuses,
    this.sequence,
    this.defaultItemId,
    this.stock,
    this.skuID,
  });

  factory MenuV1ItemsModel.fromJson(Map<String, dynamic> json) => _$MenuV1ItemsModelFromJson(json);
}

@JsonSerializable()
class MenuV1SubSectionsModel {
  int? id;
  String? title;
  String? description;
  bool? enabled;
  bool? hidden;
  @JsonKey(name: 'alc_beverages')
  bool? alcBeverages;
  List<MenuV1StatusesModel>? statuses;
  int? sequence;
  List<MenuV1ItemsModel>? items;

  MenuV1SubSectionsModel({
    this.id,
    this.title,
    this.description,
    this.enabled,
    this.hidden,
    this.alcBeverages,
    this.statuses,
    this.sequence,
    this.items,
  });

  factory MenuV1SubSectionsModel.fromJson(Map<String, dynamic> json) => _$MenuV1SubSectionsModelFromJson(json);
}

@JsonSerializable()
class MenuV1SectionsModel {
  int? id;
  String? title;
  @JsonKey(name: 'start_time')
  int? startTime;
  @JsonKey(name: 'end_time')
  int? endTime;
  @JsonKey(name: 'available_times')
  MenuV1AvailableTimesModel? availableTimes;
  String? days;
  bool? enabled;
  bool? hidden;
  List<MenuV1StatusesModel>? statuses;
  int? sequence;
  @JsonKey(name: 'sub-sections')
  List<MenuV1SubSectionsModel>? subSections;

  MenuV1SectionsModel({
    this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.availableTimes,
    this.days,
    this.enabled,
    this.hidden,
    this.statuses,
    this.sequence,
    this.subSections,
  });

  factory MenuV1SectionsModel.fromJson(Map<String, dynamic> json) => _$MenuV1SectionsModelFromJson(json);
}
