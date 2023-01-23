import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? access_token;
  String? refresh_token;
  UserInfoModel? user;

  UserModel({this.access_token, this.refresh_token, this.user});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@JsonSerializable()
class UserInfoModel {
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? phone;
  String? profile_pic;
  int? business_id;
  String? business_name;
  int? brand_id;
  String? brand_name;
  int? branch_id;
  String? branch_name;
  String? created_at;
  String? updated_at;
  String? last_login_at;
  bool? first_login;
  List<String>? roles;
  List<int>? role_ids;
  List<String>? display_roles;
  List<String>? permissions;
  List<int>? country_ids;
  List<String>? country_codes;

  UserInfoModel(
      {this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.profile_pic,
      this.business_id,
      this.business_name,
      this.brand_id,
      this.brand_name,
      this.branch_id,
      this.branch_name,
      this.created_at,
      this.updated_at,
      this.last_login_at,
      this.first_login,
      this.roles,
      this.role_ids,
      this.display_roles,
      this.permissions,
      this.country_ids,
      this.country_codes});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
}
