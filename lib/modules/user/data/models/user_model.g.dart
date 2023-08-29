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
      brand_id: json['brand_id'] as int?,
      brand_name: json['brand_name'] as String?,
      branch_id: json['branch_id'] as int?,
      branch_name: json['branch_name'] as String?,
      created_at: json['created_at'] as String?,
      updated_at: json['updated_at'] as String?,
      last_login_at: json['last_login_at'] as String?,
      first_login: json['first_login'] as bool?,
      order_notification_enabled: json['order_notification_enabled'] as bool?,
      sunmi_device: json['sunmi_device'] as bool?,
      menuv2_enabled: json['menuv2_enabled'] as bool?,
      menu_version: json['menu_version'] as int?,
      menuv2_enabled_for_klikit_order:
          json['menuv2_enabled_for_klikit_order'] as bool?,
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
      'brand_id': instance.brand_id,
      'brand_name': instance.brand_name,
      'branch_id': instance.branch_id,
      'branch_name': instance.branch_name,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'last_login_at': instance.last_login_at,
      'first_login': instance.first_login,
      'order_notification_enabled': instance.order_notification_enabled,
      'sunmi_device': instance.sunmi_device,
      'menuv2_enabled': instance.menuv2_enabled,
      'menu_version': instance.menu_version,
      'menuv2_enabled_for_klikit_order':
          instance.menuv2_enabled_for_klikit_order,
      'roles': instance.roles,
      'role_ids': instance.role_ids,
      'display_roles': instance.display_roles,
      'permissions': instance.permissions,
      'country_ids': instance.country_ids,
      'country_codes': instance.country_codes,
    };
