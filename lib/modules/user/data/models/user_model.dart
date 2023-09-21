import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? access_token;
  String? refresh_token;
  UserInfoModel? user;

  UserModel({this.access_token, this.refresh_token, this.user});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
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
  bool? first_login;
  bool? order_notification_enabled;
  bool? sunmi_device;
  bool? menuv2_enabled;
  int? menu_version;
  bool? menuv2_enabled_for_klikit_order;
  List<int>? branch_ids;
  List<String>? branch_titles;
  List<String>? roles;
  List<int>? role_ids;
  List<String>? display_roles;
  List<String>? permissions;
  List<int>? country_ids;
  List<String>? country_codes;
  List<int>? brand_ids;
  List<String>? brand_titles;

  UserInfoModel({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.profile_pic,
    this.business_id,
    this.business_name,
    this.first_login,
    this.order_notification_enabled,
    this.sunmi_device,
    this.menuv2_enabled,
    this.menu_version,
    this.menuv2_enabled_for_klikit_order,
    this.branch_ids,
    this.branch_titles,
    this.roles,
    this.role_ids,
    this.display_roles,
    this.permissions,
    this.country_ids,
    this.country_codes,
    this.brand_ids,
    this.brand_titles,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => _$UserInfoModelFromJson(json);
}
