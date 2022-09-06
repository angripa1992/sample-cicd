// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateRequestModel _$UserUpdateRequestModelFromJson(
        Map<String, dynamic> json) =>
    UserUpdateRequestModel(
      branchId: json['branch_id'] as int?,
      brandId: json['brand_id'] as int?,
      businessId: json['business_id'] as int?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String?,
      roleIds:
          (json['role_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      countryIds: (json['country_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$UserUpdateRequestModelToJson(
        UserUpdateRequestModel instance) =>
    <String, dynamic>{
      'branch_id': instance.branchId,
      'brand_id': instance.brandId,
      'business_id': instance.businessId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'phone': instance.phone,
      'role_ids': instance.roleIds,
      'country_ids': instance.countryIds,
    };
