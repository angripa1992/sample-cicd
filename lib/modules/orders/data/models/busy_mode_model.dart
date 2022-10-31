import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';

part 'busy_mode_model.g.dart';

@JsonSerializable()
class BusyModeGetResponseModel {
  @JsonKey(name: 'is_busy')
  bool? isBusy;
  @JsonKey(name: 'busy_mode_updated_at')
  String? updatedAt;
  @JsonKey(name: 'time_left')
  int? timeLeft;
  int? duration;

  BusyModeGetResponseModel({
    this.isBusy,
    this.updatedAt,
    this.duration,
    this.timeLeft,
  });

  factory BusyModeGetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BusyModeGetResponseModelFromJson(json);

  BusyModeGetResponse toEntity() {
    return BusyModeGetResponse(
      isBusy: isBusy ?? false,
      updatedAt: updatedAt.orEmpty(),
      timeLeft: timeLeft.orZero(),
      duration: duration.orZero(),
    );
  }
}

@JsonSerializable()
class BusyModePostResponseModel {
  String? message;
  List<String>? warning;
  @JsonKey(name: 'time_left')
  int? timeLeft;
  int? duration;

  BusyModePostResponseModel({
    this.message,
    this.warning,
    this.duration,
    this.timeLeft,
  });

  factory BusyModePostResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BusyModePostResponseModelFromJson(json);

  BusyModePostResponse toEntity() {
    return BusyModePostResponse(
      message: message.orEmpty(),
      warning: warning ?? [],
      duration: duration.orZero(),
      timeLeft: timeLeft.orZero(),
    );
  }
}
