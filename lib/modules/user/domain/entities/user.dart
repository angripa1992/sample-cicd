import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String accessToken;
  final String refreshToken;
  final UserInfo userInfo;

  User({
    required this.accessToken,
    required this.refreshToken,
    required this.userInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserInfo {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profilePic;
  final int businessId;
  final String businessName;
  final bool firstLogin;
  final bool orderNotificationEnabled;
  final int printingDeviceId;
  final bool menuV2Enabled;
  final int menuVersion;
  final bool menuV2EnabledForKlikitOrder;
  final int menuVersionForKlikitOrder;
  final List<int> branchIDs;
  final List<String> branchTitles;
  final List<String> roles;
  final List<int> roleIds;
  final List<String> displayRoles;
  final List<String> permissions;
  final List<int> countryIds;
  final List<String> countryCodes;
  final List<int> brandIDs;
  final List<String> brandTitles;

  UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profilePic,
    required this.businessId,
    required this.businessName,
    required this.firstLogin,
    required this.orderNotificationEnabled,
    required this.menuVersionForKlikitOrder,
    required this.printingDeviceId,
    required this.branchIDs,
    required this.branchTitles,
    required this.roles,
    required this.roleIds,
    required this.displayRoles,
    required this.permissions,
    required this.countryIds,
    required this.countryCodes,
    required this.brandIDs,
    required this.brandTitles,
    required this.menuV2Enabled,
    required this.menuVersion,
    required this.menuV2EnabledForKlikitOrder,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);

  UserInfo copyWith({String? firstName, String? lastName, String? phone}) {
    return UserInfo(
      id: id,
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email,
      phone: phone ?? '',
      profilePic: profilePic,
      businessId: businessId,
      businessName: businessName,
      firstLogin: firstLogin,
      orderNotificationEnabled: orderNotificationEnabled,
      printingDeviceId: printingDeviceId,
      branchIDs: branchIDs,
      branchTitles: branchTitles,
      roles: roles,
      roleIds: roleIds,
      displayRoles: displayRoles,
      permissions: permissions,
      countryIds: countryIds,
      countryCodes: countryCodes,
      brandIDs: brandIDs,
      brandTitles: brandTitles,
      menuV2Enabled: menuV2Enabled,
      menuVersion: menuVersion,
      menuV2EnabledForKlikitOrder: menuV2EnabledForKlikitOrder,
      menuVersionForKlikitOrder: menuVersionForKlikitOrder,
    );
  }
}
