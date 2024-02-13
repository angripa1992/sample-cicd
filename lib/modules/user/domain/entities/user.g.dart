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
      firstLogin: json['firstLogin'] as bool,
      orderNotificationEnabled: json['orderNotificationEnabled'] as bool,
      menuVersionForKlikitOrder: json['menuVersionForKlikitOrder'] as int,
      printingDeviceId: json['printingDeviceId'] as int,
      branchIDs:
          (json['branchIDs'] as List<dynamic>).map((e) => e as int).toList(),
      branchTitles: (json['branchTitles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
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
      brandIDs:
          (json['brandIDs'] as List<dynamic>).map((e) => e as int).toList(),
      brandTitles: (json['brandTitles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      menuV2Enabled: json['menuV2Enabled'] as bool,
      menuVersion: json['menuVersion'] as int,
      menuV2EnabledForKlikitOrder: json['menuV2EnabledForKlikitOrder'] as bool,
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
      'firstLogin': instance.firstLogin,
      'orderNotificationEnabled': instance.orderNotificationEnabled,
      'printingDeviceId': instance.printingDeviceId,
      'menuV2Enabled': instance.menuV2Enabled,
      'menuVersion': instance.menuVersion,
      'menuV2EnabledForKlikitOrder': instance.menuV2EnabledForKlikitOrder,
      'menuVersionForKlikitOrder': instance.menuVersionForKlikitOrder,
      'branchIDs': instance.branchIDs,
      'branchTitles': instance.branchTitles,
      'roles': instance.roles,
      'roleIds': instance.roleIds,
      'displayRoles': instance.displayRoles,
      'permissions': instance.permissions,
      'countryIds': instance.countryIds,
      'countryCodes': instance.countryCodes,
      'brandIDs': instance.brandIDs,
      'brandTitles': instance.brandTitles,
    };
