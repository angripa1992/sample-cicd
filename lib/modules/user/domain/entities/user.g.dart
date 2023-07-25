// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      userInfo: UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'userInfo': instance.userInfo,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      profilePic: json['profilePic'] as String,
      businessId: json['businessId'] as int,
      businessName: json['businessName'] as String,
      brandId: json['brandId'] as int,
      brandName: json['brandName'] as String,
      branchId: json['branchId'] as int,
      branchName: json['branchName'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      lastLoginAt: json['lastLoginAt'] as String,
      firstLogin: json['firstLogin'] as bool,
      orderNotificationEnabled: json['orderNotificationEnabled'] as bool,
      sunmiDevice: json['sunmiDevice'] as bool,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      roleIds: (json['roleIds'] as List<dynamic>).map((e) => e as int).toList(),
      displayRoles: (json['displayRoles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      countryIds:
          (json['countryIds'] as List<dynamic>).map((e) => e as int).toList(),
      countryCodes: (json['countryCodes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'profilePic': instance.profilePic,
      'businessId': instance.businessId,
      'businessName': instance.businessName,
      'brandId': instance.brandId,
      'brandName': instance.brandName,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'lastLoginAt': instance.lastLoginAt,
      'firstLogin': instance.firstLogin,
      'orderNotificationEnabled': instance.orderNotificationEnabled,
      'sunmiDevice': instance.sunmiDevice,
      'roles': instance.roles,
      'roleIds': instance.roleIds,
      'displayRoles': instance.displayRoles,
      'permissions': instance.permissions,
      'countryIds': instance.countryIds,
      'countryCodes': instance.countryCodes,
    };
