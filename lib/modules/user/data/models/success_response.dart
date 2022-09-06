import 'package:json_annotation/json_annotation.dart';

part 'success_response.g.dart';

@JsonSerializable()
class SuccessResponseModel{
  final String? message;

  SuccessResponseModel(this.message);

  factory SuccessResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SuccessResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessResponseModelToJson(this);
}