import 'package:json_annotation/json_annotation.dart';

part 'reset_link_request_model.g.dart';

@JsonSerializable()
class ResetLinkRequestModel {
  final String email;

  ResetLinkRequestModel(this.email);

  Map<String, dynamic> toJson() => _$ResetLinkRequestModelToJson(this);
}
