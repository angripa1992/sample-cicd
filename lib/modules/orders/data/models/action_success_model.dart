import 'package:json_annotation/json_annotation.dart';

part 'action_success_model.g.dart';

@JsonSerializable()
class ActionSuccess{
  final String? message;

  ActionSuccess(this.message);

  factory ActionSuccess.fromJson(Map<String, dynamic> json) =>
      _$ActionSuccessFromJson(json);
}