import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';

part 'busy_mode_model.g.dart';

@JsonSerializable()
class BusyModeGetResponseModel {
  @JsonKey(name: 'is_busy')
  bool? isBusy;

  BusyModeGetResponseModel({this.isBusy});

  factory BusyModeGetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BusyModeGetResponseModelFromJson(json);

  BusyModeGetResponse toEntity() {
    return BusyModeGetResponse(isBusy: isBusy ?? false);
  }
}

@JsonSerializable()
class BusyModePostResponseModel {
  String? message;
  List<String>? warning;

  BusyModePostResponseModel({this.message, this.warning});

  factory BusyModePostResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BusyModePostResponseModelFromJson(json);

  BusyModePostResponse toEntity() {
    return BusyModePostResponse(
      message: message.orEmpty(),
      warning: warning ?? [],
    );
  }
}
