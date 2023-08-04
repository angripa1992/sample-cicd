import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../../domain/entities/menu/menu_out_of_stock.dart';

part 'menu_out_of_stock_model.g.dart';

@JsonSerializable()
class MenuOutOfStockModel {
  bool? available;
  MenuSnoozeModel? snooze;

  MenuOutOfStockModel({
    this.available,
    this.snooze,
  });

  factory MenuOutOfStockModel.fromJson(Map<String, dynamic> json) =>
      _$MenuOutOfStockModelFromJson(json);

  MenuOutOfStock toEntity() {
    return MenuOutOfStock(
      available: available.orFalse(),
      menuSnooze: snooze?.toEntity() ?? MenuSnoozeModel().toEntity(),
    );
  }
}

@JsonSerializable()
class MenuSnoozeModel {
  @JsonKey(name: 'end_time')
  String? endTime;
  int? duration;

  MenuSnoozeModel({
    this.endTime,
    this.duration,
  });

  factory MenuSnoozeModel.fromJson(Map<String, dynamic> json) =>
      _$MenuSnoozeModelFromJson(json);

  MenuSnooze toEntity() {
    return MenuSnooze(
      endTime: endTime.orEmpty(),
      duration: duration.orZero(),
    );
  }
}
