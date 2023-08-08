// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_v2_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuV2DataModel _$MenuV2DataModelFromJson(Map<String, dynamic> json) =>
    MenuV2DataModel(
      branchInfo: json['branchInfo'] == null
          ? null
          : MenuV2BranchInfo.fromJson(
              json['branchInfo'] as Map<String, dynamic>),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => MenuV2Sections.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV2DataModelToJson(MenuV2DataModel instance) =>
    <String, dynamic>{
      'branchInfo': instance.branchInfo,
      'sections': instance.sections,
    };

MenuV2BranchInfo _$MenuV2BranchInfoFromJson(Map<String, dynamic> json) =>
    MenuV2BranchInfo(
      businessID: json['businessID'] as int?,
      brandID: json['brandID'] as int?,
      branchID: json['branchID'] as int?,
      countryID: json['countryID'] as int?,
      currencyID: json['currencyID'] as int?,
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
      availabilityMask: json['availabilityMask'] as int?,
      providerIDs: json['providerIDs'] as String?,
      languageCode: json['languageCode'] as String?,
      currencyCode: json['currencyCode'] as String?,
    );

Map<String, dynamic> _$MenuV2BranchInfoToJson(MenuV2BranchInfo instance) =>
    <String, dynamic>{
      'businessID': instance.businessID,
      'brandID': instance.brandID,
      'branchID': instance.branchID,
      'countryID': instance.countryID,
      'currencyID': instance.currencyID,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'availabilityMask': instance.availabilityMask,
      'providerIDs': instance.providerIDs,
      'languageCode': instance.languageCode,
      'currencyCode': instance.currencyCode,
    };

MenuV2Sections _$MenuV2SectionsFromJson(Map<String, dynamic> json) =>
    MenuV2Sections(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : MenuV2Title.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : MenuV2Title.fromJson(json['description'] as Map<String, dynamic>),
      availableTimes: json['availableTimes'] == null
          ? null
          : MenuV2AvailableTimesModel.fromJson(
              json['availableTimes'] as Map<String, dynamic>),
      isAvailable: json['isAvailable'] as bool?,
      enabled: json['enabled'] as bool?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => MenuV2Visibility.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => MenuV2Category.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV2SectionsToJson(MenuV2Sections instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'availableTimes': instance.availableTimes,
      'isAvailable': instance.isAvailable,
      'enabled': instance.enabled,
      'visibilities': instance.visibilities,
      'sequence': instance.sequence,
      'categories': instance.categories,
    };

MenuV2Title _$MenuV2TitleFromJson(Map<String, dynamic> json) => MenuV2Title(
      en: json['en'] as String?,
      tl: json['tl'] as String?,
    );

Map<String, dynamic> _$MenuV2TitleToJson(MenuV2Title instance) =>
    <String, dynamic>{
      'en': instance.en,
      'tl': instance.tl,
    };

MenuV2AvailableTimesModel _$MenuV2AvailableTimesModelFromJson(
        Map<String, dynamic> json) =>
    MenuV2AvailableTimesModel(
      sunday: json['0'] == null
          ? null
          : MenuV2DayInfoModel.fromJson(json['0'] as Map<String, dynamic>),
      monday: json['1'] == null
          ? null
          : MenuV2DayInfoModel.fromJson(json['1'] as Map<String, dynamic>),
      tuesday: json['2'] == null
          ? null
          : MenuV2DayInfoModel.fromJson(json['2'] as Map<String, dynamic>),
      wednesday: json['3'] == null
          ? null
          : MenuV2DayInfoModel.fromJson(json['3'] as Map<String, dynamic>),
      thursday: json['4'] == null
          ? null
          : MenuV2DayInfoModel.fromJson(json['4'] as Map<String, dynamic>),
      friday: json['5'] == null
          ? null
          : MenuV2DayInfoModel.fromJson(json['5'] as Map<String, dynamic>),
      saturday: json['6'] == null
          ? null
          : MenuV2DayInfoModel.fromJson(json['6'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuV2AvailableTimesModelToJson(
        MenuV2AvailableTimesModel instance) =>
    <String, dynamic>{
      '0': instance.sunday,
      '1': instance.monday,
      '2': instance.tuesday,
      '3': instance.wednesday,
      '4': instance.thursday,
      '5': instance.friday,
      '6': instance.saturday,
    };

MenuV2DayInfoModel _$MenuV2DayInfoModelFromJson(Map<String, dynamic> json) =>
    MenuV2DayInfoModel(
      disabled: json['disabled'] as bool?,
      slots: (json['slots'] as List<dynamic>?)
          ?.map((e) => MenuV2SlotsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV2DayInfoModelToJson(MenuV2DayInfoModel instance) =>
    <String, dynamic>{
      'disabled': instance.disabled,
      'slots': instance.slots,
    };

MenuV2SlotsModel _$MenuV2SlotsModelFromJson(Map<String, dynamic> json) =>
    MenuV2SlotsModel(
      startTime: json['startTime'] as int?,
      endTime: json['endTime'] as int?,
    );

Map<String, dynamic> _$MenuV2SlotsModelToJson(MenuV2SlotsModel instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };

MenuV2Visibility _$MenuV2VisibilityFromJson(Map<String, dynamic> json) =>
    MenuV2Visibility(
      providerID: json['providerID'] as int?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$MenuV2VisibilityToJson(MenuV2Visibility instance) =>
    <String, dynamic>{
      'providerID': instance.providerID,
      'status': instance.status,
    };

MenuV2Category _$MenuV2CategoryFromJson(Map<String, dynamic> json) =>
    MenuV2Category(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : MenuV2Title.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : MenuV2Title.fromJson(json['description'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool?,
      alcBeverages: json['alcBeverages'] as bool?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => MenuV2Visibility.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MenuV2CategoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV2CategoryToJson(MenuV2Category instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'enabled': instance.enabled,
      'alcBeverages': instance.alcBeverages,
      'visibilities': instance.visibilities,
      'sequence': instance.sequence,
      'items': instance.items,
    };

MenuV2CategoryItem _$MenuV2CategoryItemFromJson(Map<String, dynamic> json) =>
    MenuV2CategoryItem(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : MenuV2Title.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : MenuV2Title.fromJson(json['description'] as Map<String, dynamic>),
      vat: json['vat'] as int?,
      enabled: json['enabled'] as bool?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => MenuV2Visibility.fromJson(e as Map<String, dynamic>))
          .toList(),
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => MenuV2Price.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemIsEnabled: json['itemIsEnabled'] as bool?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => MenuV2Resources.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      oos: json['oos'] == null
          ? null
          : MenuV2Oos.fromJson(json['oos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuV2CategoryItemToJson(MenuV2CategoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'vat': instance.vat,
      'enabled': instance.enabled,
      'visibilities': instance.visibilities,
      'prices': instance.prices,
      'itemIsEnabled': instance.itemIsEnabled,
      'resources': instance.resources,
      'sequence': instance.sequence,
      'oos': instance.oos,
    };

MenuV2Price _$MenuV2PriceFromJson(Map<String, dynamic> json) => MenuV2Price(
      providerID: json['providerID'] as int?,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => MenuV2PriceDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV2PriceToJson(MenuV2Price instance) =>
    <String, dynamic>{
      'providerID': instance.providerID,
      'details': instance.details,
    };

MenuV2PriceDetails _$MenuV2PriceDetailsFromJson(Map<String, dynamic> json) =>
    MenuV2PriceDetails(
      currencyCode: json['currencyCode'] as String?,
      price: json['price'] as int?,
      takeAwayPrice: json['takeAwayPrice'] as int?,
    );

Map<String, dynamic> _$MenuV2PriceDetailsToJson(MenuV2PriceDetails instance) =>
    <String, dynamic>{
      'currencyCode': instance.currencyCode,
      'price': instance.price,
      'takeAwayPrice': instance.takeAwayPrice,
    };

MenuV2Resources _$MenuV2ResourcesFromJson(Map<String, dynamic> json) =>
    MenuV2Resources(
      providerID: json['providerID'] as int?,
      type: json['type'] as String?,
      paths: (json['paths'] as List<dynamic>?)
          ?.map((e) => MenuV2ResourcePaths.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV2ResourcesToJson(MenuV2Resources instance) =>
    <String, dynamic>{
      'providerID': instance.providerID,
      'type': instance.type,
      'paths': instance.paths,
    };

MenuV2ResourcePaths _$MenuV2ResourcePathsFromJson(Map<String, dynamic> json) =>
    MenuV2ResourcePaths(
      path: json['path'] as String?,
      sequence: json['sequence'] as int?,
      byDefault: json['default'] as bool?,
    );

Map<String, dynamic> _$MenuV2ResourcePathsToJson(
        MenuV2ResourcePaths instance) =>
    <String, dynamic>{
      'path': instance.path,
      'sequence': instance.sequence,
      'default': instance.byDefault,
    };

MenuV2Oos _$MenuV2OosFromJson(Map<String, dynamic> json) => MenuV2Oos(
      available: json['available'] as bool?,
      snooze: json['snooze'] == null
          ? null
          : MenuV2Snooze.fromJson(json['snooze'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuV2OosToJson(MenuV2Oos instance) => <String, dynamic>{
      'available': instance.available,
      'snooze': instance.snooze,
    };

MenuV2Snooze _$MenuV2SnoozeFromJson(Map<String, dynamic> json) => MenuV2Snooze(
      endTime: json['endTime'] as String?,
      duration: json['duration'] as int?,
    );

Map<String, dynamic> _$MenuV2SnoozeToJson(MenuV2Snooze instance) =>
    <String, dynamic>{
      'endTime': instance.endTime,
      'duration': instance.duration,
    };
