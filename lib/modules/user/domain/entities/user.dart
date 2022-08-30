import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String accessToken;
  final String refreshToken;
  final UserInfo userInfo;

  User({required this.accessToken,required this.refreshToken,required this.userInfo});

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String,dynamic> toJson() => _$UserToJson(this);
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
  final int brandId;
  final String brandName;
  final int branchId;
  final String branchName;
  final String createdAt;
  final String updatedAt;
  final String lastLoginAt;
  final bool firstLogin;
  final List<String> roles;
  final List<int> roleIds;
  final List<String> displayRoles;
  final List<String> permissions;

  UserInfo(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.profilePic,
      required this.businessId,
      required this.businessName,
      required this.brandId,
      required this.brandName,
      required this.branchId,
      required this.branchName,
      required this.createdAt,
      required this.updatedAt,
      required this.lastLoginAt,
      required this.firstLogin,
      required this.roles,
      required this.roleIds,
      required this.displayRoles,
      required this.permissions});

  factory UserInfo.fromJson(Map<String,dynamic> json) => _$UserInfoFromJson(json);
  Map<String,dynamic> toJson() => _$UserInfoToJson(this);
}
