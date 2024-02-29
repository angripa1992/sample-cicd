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
      currencySymbol: json['currencySymbol'] as String?,
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
      'currencySymbol': instance.currencySymbol,
    };

MenuV2Sections _$MenuV2SectionsFromJson(Map<String, dynamic> json) =>
    MenuV2Sections(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : V2TitleModel.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : V2TitleModel.fromJson(json['description'] as Map<String, dynamic>),
      availableTimes: json['availableTimes'] == null
          ? null
          : MenuV2AvailableTimesModel.fromJson(
              json['availableTimes'] as Map<String, dynamic>),
      isAvailable: json['isAvailable'] as bool?,
      enabled: json['enabled'] as bool?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => V2VisibilityModel.fromJson(e as Map<String, dynamic>))
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

MenuV2Category _$MenuV2CategoryFromJson(Map<String, dynamic> json) =>
    MenuV2Category(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : V2TitleModel.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : V2TitleModel.fromJson(json['description'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool?,
      isPopularCategory: json['isPopularCategory'] as bool?,
      alcBeverages: json['alcBeverages'] as bool?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => V2VisibilityModel.fromJson(e as Map<String, dynamic>))
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
      'isPopularCategory': instance.isPopularCategory,
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
          : V2TitleModel.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : V2TitleModel.fromJson(json['description'] as Map<String, dynamic>),
      vat: json['vat'] as int?,
      skuID: json['skuID'] as String?,
      categoryId: json['category_id'] as int?,
      enabled: json['enabled'] as bool?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => V2VisibilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => V2PriceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemIsEnabled: json['itemIsEnabled'] as bool?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => V2ResourcesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      oos: json['oos'] == null
          ? null
          : V2OosModel.fromJson(json['oos'] as Map<String, dynamic>),
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => V2ModifierGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV2CategoryItemToJson(MenuV2CategoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'vat': instance.vat,
      'skuID': instance.skuID,
      'category_id': instance.categoryId,
      'enabled': instance.enabled,
      'visibilities': instance.visibilities,
      'prices': instance.prices,
      'itemIsEnabled': instance.itemIsEnabled,
      'resources': instance.resources,
      'sequence': instance.sequence,
      'oos': instance.oos,
      'groups': instance.groups,
    };
