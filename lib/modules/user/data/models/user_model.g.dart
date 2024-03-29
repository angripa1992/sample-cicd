// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      access_token: json['access_token'] as String?,
      refresh_token: json['refresh_token'] as String?,
      user: json['user'] == null
          ? null
          : UserInfoModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'access_token': instance.access_token,
      'refresh_token': instance.refresh_token,
      'user': instance.user,
    };

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      id: json['id'] as int?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      email: json['email'] as String?,
      profile_pic: json['profile_pic'] as String?,
      business_id: json['business_id'] as int?,
      business_name: json['business_name'] as String?,
      first_login: json['first_login'] as bool?,
      order_notification_enabled: json['order_notification_enabled'] as bool?,
      printing_device_id: json['printing_device_id'] as int?,
      menuv2_enabled: json['menuv2_enabled'] as bool?,
      menu_version: json['menu_version'] as int?,
      menuv2_enabled_for_klikit_order:
          json['menuv2_enabled_for_klikit_order'] as bool?,
      menu_version_for_klikit_order:
          json['menu_version_for_klikit_order'] as int?,
      branch_ids:
          (json['branch_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      branch_titles: (json['branch_titles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      role_ids:
          (json['role_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      display_roles: (json['display_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      country_ids: (json['country_ids'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      country_codes: (json['country_codes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      brand_ids:
          (json['brand_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      brand_titles: (json['brand_titles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )..phone = json['phone'] as String?;

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'phone': instance.phone,
      'profile_pic': instance.profile_pic,
      'business_id': instance.business_id,
      'business_name': instance.business_name,
      'first_login': instance.first_login,
      'order_notification_enabled': instance.order_notification_enabled,
      'printing_device_id': instance.printing_device_id,
      'menuv2_enabled': instance.menuv2_enabled,
      'menu_version': instance.menu_version,
      'menuv2_enabled_for_klikit_order':
          instance.menuv2_enabled_for_klikit_order,
      'menu_version_for_klikit_order': instance.menu_version_for_klikit_order,
      'branch_ids': instance.branch_ids,
      'branch_titles': instance.branch_titles,
      'roles': instance.roles,
      'role_ids': instance.role_ids,
      'display_roles': instance.display_roles,
      'permissions': instance.permissions,
      'country_ids': instance.country_ids,
      'country_codes': instance.country_codes,
      'brand_ids': instance.brand_ids,
      'brand_titles': instance.brand_titles,
    };
