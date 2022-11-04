import 'package:klikit/modules/menu/domain/entities/status.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';

import 'avilable_times.dart';

class Sections {
  final int id;
  final String title;
  final int startTime;
  final int endTime;
  final AvailableTimes availableTimes;
  final String days;
  final bool enabled;
  final bool hidden;
  final List<Statuses> statuses;
  final int sequence;
  final List<SubSections> subSections;

  Sections({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.availableTimes,
    required this.days,
    required this.enabled,
    required this.hidden,
    required this.statuses,
    required this.sequence,
    required this.subSections,
  });
}
