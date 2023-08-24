import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/data/models/status_model.dart';
import 'package:klikit/modules/menu/data/models/sub_section_model.dart';

import '../../domain/entities/sections.dart';
import 'availables_time_model.dart';

part 'sections_model.g.dart';

@JsonSerializable()
class SectionsModel {
  int? id;
  String? title;
  @JsonKey(name: 'start_time')
  int? startTime;
  @JsonKey(name: 'end_time')
  int? endTime;
  @JsonKey(name: 'available_times')
  AvailableTimesModel? availableTimes;
  String? days;
  bool? enabled;
  bool? hidden;
  List<StatusesModel>? statuses;
  int? sequence;
  @JsonKey(name: 'sub-sections')
  List<SubSectionsModel>? subSections;

  SectionsModel({
    this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.availableTimes,
    this.days,
    this.enabled,
    this.hidden,
    this.statuses,
    this.sequence,
    this.subSections,
  });

  factory SectionsModel.fromJson(Map<String, dynamic> json) =>
      _$SectionsModelFromJson(json);

  Sections toEntity() {
    return Sections(
      id: id.orZero(),
      title: title.orEmpty(),
      startTime: startTime.orZero(),
      endTime: endTime.orZero(),
      availableTimes:
          availableTimes?.toEntity() ?? AvailableTimesModel().toEntity(),
      days: days.orEmpty(),
      enabled: enabled.orFalse(),
      hidden: hidden.orFalse(),
      statuses: statuses?.map((e) => e.toEntity()).toList() ?? [],
      sequence: sequence.orZero(),
      subSections: subSections?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
