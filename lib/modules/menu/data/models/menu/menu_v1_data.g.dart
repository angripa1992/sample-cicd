// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_v1_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuV1MenusDataModel _$MenuV1MenusDataModelFromJson(
        Map<String, dynamic> json) =>
    MenuV1MenusDataModel(
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => MenuV1SectionsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      branchInfo: json['branch_info'] == null
          ? null
          : MenuV1BranchInfo.fromJson(
              json['branch_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuV1MenusDataModelToJson(
        MenuV1MenusDataModel instance) =>
    <String, dynamic>{
      'sections': instance.sections,
      'branch_info': instance.branchInfo,
    };

MenuV1BranchInfo _$MenuV1BranchInfoFromJson(Map<String, dynamic> json) =>
    MenuV1BranchInfo(
      branchId: json['branch_id'] as int?,
      countryId: json['country_id'] as int?,
      currencyId: json['currency_id'] as int?,
      startTime: json['start_time'] as int?,
      endTime: json['end_time'] as int?,
      availabilityMask: json['availability_mask'] as int?,
      providerIds: json['provider_ids'] as String?,
      languageCode: json['language_code'] as String?,
    );

Map<String, dynamic> _$MenuV1BranchInfoToJson(MenuV1BranchInfo instance) =>
    <String, dynamic>{
      'branch_id': instance.branchId,
      'country_id': instance.countryId,
      'currency_id': instance.currencyId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'availability_mask': instance.availabilityMask,
      'provider_ids': instance.providerIds,
      'language_code': instance.languageCode,
    };

MenuV1AvailableTimesModel _$MenuV1AvailableTimesModelFromJson(
        Map<String, dynamic> json) =>
    MenuV1AvailableTimesModel(
      sunday: json['0'] == null
          ? null
          : MenuV1DayInfoModel.fromJson(json['0'] as Map<String, dynamic>),
      monday: json['1'] == null
          ? null
          : MenuV1DayInfoModel.fromJson(json['1'] as Map<String, dynamic>),
      tuesday: json['2'] == null
          ? null
          : MenuV1DayInfoModel.fromJson(json['2'] as Map<String, dynamic>),
      wednesday: json['3'] == null
          ? null
          : MenuV1DayInfoModel.fromJson(json['3'] as Map<String, dynamic>),
      thursday: json['4'] == null
          ? null
          : MenuV1DayInfoModel.fromJson(json['4'] as Map<String, dynamic>),
      friday: json['5'] == null
          ? null
          : MenuV1DayInfoModel.fromJson(json['5'] as Map<String, dynamic>),
      saturday: json['6'] == null
          ? null
          : MenuV1DayInfoModel.fromJson(json['6'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuV1AvailableTimesModelToJson(
        MenuV1AvailableTimesModel instance) =>
    <String, dynamic>{
      '0': instance.sunday,
      '1': instance.monday,
      '2': instance.tuesday,
      '3': instance.wednesday,
      '4': instance.thursday,
      '5': instance.friday,
      '6': instance.saturday,
    };

MenuV1DayInfoModel _$MenuV1DayInfoModelFromJson(Map<String, dynamic> json) =>
    MenuV1DayInfoModel(
      disabled: json['disabled'] as bool?,
      slots: (json['slots'] as List<dynamic>?)
          ?.map((e) => MenuV1SlotsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV1DayInfoModelToJson(MenuV1DayInfoModel instance) =>
    <String, dynamic>{
      'disabled': instance.disabled,
      'slots': instance.slots,
    };

MenuV1SlotsModel _$MenuV1SlotsModelFromJson(Map<String, dynamic> json) =>
    MenuV1SlotsModel(
      startTime: json['start_time'] as int?,
      endTime: json['end_time'] as int?,
    );

Map<String, dynamic> _$MenuV1SlotsModelToJson(MenuV1SlotsModel instance) =>
    <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };

MenuV1StatusesModel _$MenuV1StatusesModelFromJson(Map<String, dynamic> json) =>
    MenuV1StatusesModel(
      providerId: json['provider_id'] as int?,
      hidden: json['hidden'] as bool?,
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$MenuV1StatusesModelToJson(
        MenuV1StatusesModel instance) =>
    <String, dynamic>{
      'provider_id': instance.providerId,
      'hidden': instance.hidden,
      'enabled': instance.enabled,
    };

MenuV1StockModel _$MenuV1StockModelFromJson(Map<String, dynamic> json) =>
    MenuV1StockModel(
      available: json['available'] as bool?,
      snooze: json['snooze'] == null
          ? null
          : MenuV1SnoozeModel.fromJson(json['snooze'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuV1StockModelToJson(MenuV1StockModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'snooze': instance.snooze,
    };

MenuV1SnoozeModel _$MenuV1SnoozeModelFromJson(Map<String, dynamic> json) =>
    MenuV1SnoozeModel(
      endTime: json['end_time'] as String?,
      duration: json['duration'] as int?,
    );

Map<String, dynamic> _$MenuV1SnoozeModelToJson(MenuV1SnoozeModel instance) =>
    <String, dynamic>{
      'end_time': instance.endTime,
      'duration': instance.duration,
    };

MenuV1SectionsModel _$MenuV1SectionsModelFromJson(Map<String, dynamic> json) =>
    MenuV1SectionsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      startTime: json['start_time'] as int?,
      endTime: json['end_time'] as int?,
      availableTimes: json['available_times'] == null
          ? null
          : MenuV1AvailableTimesModel.fromJson(
              json['available_times'] as Map<String, dynamic>),
      days: json['days'] as String?,
      enabled: json['enabled'] as bool?,
      hidden: json['hidden'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => MenuV1StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      subSections: (json['sub-sections'] as List<dynamic>?)
          ?.map(
              (e) => MenuV1SubSectionsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV1SectionsModelToJson(
        MenuV1SectionsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'available_times': instance.availableTimes,
      'days': instance.days,
      'enabled': instance.enabled,
      'hidden': instance.hidden,
      'statuses': instance.statuses,
      'sequence': instance.sequence,
      'sub-sections': instance.subSections,
    };

MenuV1SubSectionsModel _$MenuV1SubSectionsModelFromJson(
        Map<String, dynamic> json) =>
    MenuV1SubSectionsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool?,
      hidden: json['hidden'] as bool?,
      alcBeverages: json['alc_beverages'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => MenuV1StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MenuV1ItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuV1SubSectionsModelToJson(
        MenuV1SubSectionsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'enabled': instance.enabled,
      'hidden': instance.hidden,
      'alc_beverages': instance.alcBeverages,
      'statuses': instance.statuses,
      'sequence': instance.sequence,
      'items': instance.items,
    };

MenuV1ItemsModel _$MenuV1ItemsModelFromJson(Map<String, dynamic> json) =>
    MenuV1ItemsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => V1PricesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      vat: json['vat'] as int?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      enabled: json['enabled'] as bool?,
      hidden: json['hidden'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => MenuV1StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      defaultItemId: json['default_item_id'] as int?,
      stock: json['stock'] == null
          ? null
          : MenuV1StockModel.fromJson(json['stock'] as Map<String, dynamic>),
      skuID: json['sku_id'] as String?,
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => V1ModifierGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      haveModifier: json['item_modifier_group_exists'] as bool?,
    );

Map<String, dynamic> _$MenuV1ItemsModelToJson(MenuV1ItemsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'prices': instance.prices,
      'vat': instance.vat,
      'description': instance.description,
      'image': instance.image,
      'enabled': instance.enabled,
      'hidden': instance.hidden,
      'statuses': instance.statuses,
      'sequence': instance.sequence,
      'stock': instance.stock,
      'default_item_id': instance.defaultItemId,
      'sku_id': instance.skuID,
      'groups': instance.groups,
      'item_modifier_group_exists': instance.haveModifier,
    };
