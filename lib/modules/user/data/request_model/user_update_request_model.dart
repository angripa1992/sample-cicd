import 'package:json_annotation/json_annotation.dart';

part 'user_update_request_model.g.dart';

@JsonSerializable()
class UserUpdateRequestModel {
  @JsonKey(name: 'branch_id')
  int? branchId;
  @JsonKey(name: 'business_id')
  int? businessId;
  @JsonKey(name: 'first_name')
  String? firstName;
  @JsonKey(name: 'last_name')
  String? lastName;
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'role_ids')
  List<int>? roleIds;
  @JsonKey(name: 'country_ids')
  List<int>? countryIds;

  UserUpdateRequestModel({
    this.branchId,
    this.businessId,
    this.firstName,
    this.lastName,
    this.phone,
    this.roleIds,
    this.countryIds,
  });

  factory UserUpdateRequestModel.fromJson(Map<String, dynamic> json) => _$UserUpdateRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateRequestModelToJson(this);
}
