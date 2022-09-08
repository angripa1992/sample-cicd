import 'package:json_annotation/json_annotation.dart';

part 'change_password_request_model.g.dart';

@JsonSerializable()
class ChangePasswordRequestModel{
  final String old_password;
  final String new_password;

  ChangePasswordRequestModel(this.old_password, this.new_password);

  Map<String,dynamic> toJson() => _$ChangePasswordRequestModelToJson(this);
}