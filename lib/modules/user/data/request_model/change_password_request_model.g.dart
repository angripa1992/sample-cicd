// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequestModel _$ChangePasswordRequestModelFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordRequestModel(
      json['old_password'] as String,
      json['new_password'] as String,
    );

Map<String, dynamic> _$ChangePasswordRequestModelToJson(
        ChangePasswordRequestModel instance) =>
    <String, dynamic>{
      'old_password': instance.old_password,
      'new_password': instance.new_password,
    };
