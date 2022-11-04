import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/status.dart';

part 'status_model.g.dart';

@JsonSerializable()
class StatusesModel {
  @JsonKey(name: 'provider_id')
  int? providerId;
  bool? hidden;
  bool? enabled;

  StatusesModel({
    this.providerId,
    this.hidden,
    this.enabled,
  });

  factory StatusesModel.fromJson(Map<String, dynamic> json) =>
      _$StatusesModelFromJson(json);

  Statuses toEntity() {
    return Statuses(
      providerId: providerId.orZero(),
      hidden: hidden.orFalse(),
      enabled: enabled.orFalse(),
    );
  }
}
