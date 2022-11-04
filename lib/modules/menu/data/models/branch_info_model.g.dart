// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchInfoModel _$BranchInfoModelFromJson(Map<String, dynamic> json) =>
    BranchInfoModel(
      countryId: json['country_id'] as int?,
      branchId: json['branch_id'] as int?,
      currencyId: json['currency_id'] as int?,
      startTime: json['start_time'] as int?,
      endTime: json['end_time'] as int?,
      availabilityMask: json['availability_mask'] as int?,
      providerIds: json['provider_ids'] as String?,
      languageCode: json['language_code'] as String?,
    );

Map<String, dynamic> _$BranchInfoModelToJson(BranchInfoModel instance) =>
    <String, dynamic>{
      'country_id': instance.countryId,
      'branch_id': instance.branchId,
      'currency_id': instance.currencyId,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'availability_mask': instance.availabilityMask,
      'provider_ids': instance.providerIds,
      'language_code': instance.languageCode,
    };
