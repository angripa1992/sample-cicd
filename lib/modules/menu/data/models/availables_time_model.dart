import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/avilable_times.dart';

part 'availables_time_model.g.dart';

@JsonSerializable()
class AvailableTimesModel {
  @JsonKey(name: '0')
  DayInfoModel? sunday;
  @JsonKey(name: '1')
  DayInfoModel? monday;
  @JsonKey(name: '2')
  DayInfoModel? tuesday;
  @JsonKey(name: '3')
  DayInfoModel? wednesday;
  @JsonKey(name: '4')
  DayInfoModel? thursday;
  @JsonKey(name: '5')
  DayInfoModel? friday;
  @JsonKey(name: '6')
  DayInfoModel? saturday;

  AvailableTimesModel({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
  });

  factory AvailableTimesModel.fromJson(Map<String, dynamic> json) =>
      _$AvailableTimesModelFromJson(json);

  AvailableTimes toEntity() {
    return AvailableTimes(
      sunday: sunday?.toEntity() ?? DayInfoModel().toEntity(),
      monday: monday?.toEntity() ?? DayInfoModel().toEntity(),
      tuesday: tuesday?.toEntity() ?? DayInfoModel().toEntity(),
      wednesday: wednesday?.toEntity() ?? DayInfoModel().toEntity(),
      thursday: thursday?.toEntity() ?? DayInfoModel().toEntity(),
      friday: friday?.toEntity() ?? DayInfoModel().toEntity(),
      saturday: saturday?.toEntity() ?? DayInfoModel().toEntity(),
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
