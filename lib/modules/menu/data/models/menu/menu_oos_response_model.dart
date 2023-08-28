import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../../domain/entities/menu/menu_out_of_stock.dart';

part 'menu_oos_response_model.g.dart';

@JsonSerializable()
class MenuOosV2ResponseModel {
  MenuOosResponseModel? oos;

  MenuOosV2ResponseModel({
    this.oos,
  });

  factory MenuOosV2ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MenuOosV2ResponseModelFromJson(json);
}

@JsonSerializable()
class MenuOosResponseModel {
  bool? available;
  MenuSnoozeResponseModel? snooze;

  MenuOosResponseModel({
    this.available,
    this.snooze,
  });

  factory MenuOosResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MenuOosResponseModelFromJson(json);

  MenuOutOfStock toEntity() {
    return MenuOutOfStock(
      available: available.orFalse(),
      menuSnooze: snooze?.toEntity() ?? MenuSnoozeResponseModel().toEntity(),
    );
  }
}

@JsonSerializable()
class MenuSnoozeResponseModel {
  @JsonKey(name: 'start_time')
  String? startTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  int? duration;
  String? unit;

  MenuSnoozeResponseModel({
    this.startTime,
    this.endTime,
    this.duration,
    this.unit,
  });

  factory MenuSnoozeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MenuSnoozeResponseModelFromJson(json);

  MenuSnooze toEntity() {
    return MenuSnooze(
      startTime: startTime.orEmpty(),
      endTime: endTime.orEmpty(),
      duration: duration.orZero(),
      unit: unit.orEmpty(),
    );
  }
}
