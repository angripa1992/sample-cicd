import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/avilable_times.dart';

part 'availables_time_model.g.dart';

@JsonSerializable()
class AvailableTimesModel {
  @JsonKey(name: '0')
  DayInfoModel? dayOne;
  @JsonKey(name: '1')
  DayInfoModel? dayTwo;
  @JsonKey(name: '2')
  DayInfoModel? dayThree;
  @JsonKey(name: '3')
  DayInfoModel? dayFour;
  @JsonKey(name: '4')
  DayInfoModel? dayFive;
  @JsonKey(name: '5')
  DayInfoModel? daySix;
  @JsonKey(name: '6')
  DayInfoModel? daySeven;

  AvailableTimesModel({
    this.dayOne,
    this.dayTwo,
    this.dayThree,
    this.dayFour,
    this.dayFive,
    this.daySix,
    this.daySeven,
  });

  factory AvailableTimesModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableTimesModelFromJson(json);

  AvailableTimes toEntity() {
    return AvailableTimes(
      dayOne: dayOne?.toEntity() ?? DayInfoModel().toEntity(),
      dayTwo: dayTwo?.toEntity() ?? DayInfoModel().toEntity(),
      dayThree: dayThree?.toEntity() ?? DayInfoModel().toEntity(),
      dayFour: dayFour?.toEntity() ?? DayInfoModel().toEntity(),
      dayFive: dayFive?.toEntity() ?? DayInfoModel().toEntity(),
      daySix: daySix?.toEntity() ?? DayInfoModel().toEntity(),
      daySeven: daySeven?.toEntity() ?? DayInfoModel().toEntity(),
    );
  }
}

@JsonSerializable()
class DayInfoModel {
  bool? disabled;
  List<SlotsModel>? slots;

  DayInfoModel({
    this.disabled,
    this.slots,
  });

  factory DayInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DayInfoModelFromJson(json);

  DayInfo toEntity() {
    return DayInfo(disabled: disabled.orFalse(), slots: _slots());
  }

  List<Slots> _slots() {
    List<Slots> slotsData = [];
    if (slots == null) return slotsData;
    for (var element in slots!) {
      slotsData.add(element.toEntity());
    }
    return slotsData;
  }
}

@JsonSerializable()
class SlotsModel {
  @JsonKey(name: 'start_time')
  int? startTime;
  @JsonKey(name: 'end_time')
  int? endTime;

  SlotsModel({
    this.startTime,
    this.endTime,
  });

  factory SlotsModel.fromJson(Map<String, dynamic> json) =>
      _$SlotsModelFromJson(json);

  Slots toEntity() {
    return Slots(
      startTime: startTime.orZero(),
      endTime: endTime.orZero(),
    );
  }
}
