import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/stock.dart';

part 'stock_model.g.dart';

@JsonSerializable()
class StockModel {
  bool? available;
  SnoozeModel? snooze;

  StockModel({
    this.available,
    this.snooze,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) =>
      _$StockModelFromJson(json);

  Stock toEntity() {
    return Stock(
      available: available.orFalse(),
      snooze: snooze?.toEntity() ?? SnoozeModel().toEntity(),
    );
  }
}

@JsonSerializable()
class SnoozeModel {
  @JsonKey(name: 'end_time')
  String? endTime;
  int? duration;

  SnoozeModel({
    this.endTime,
    this.duration,
  });

  factory SnoozeModel.fromJson(Map<String, dynamic> json) =>
      _$SnoozeModelFromJson(json);

  Snooze toEntity() {
    return Snooze(
      endTime: endTime.orEmpty(),
      duration: duration.orZero(),
    );
  }
}
