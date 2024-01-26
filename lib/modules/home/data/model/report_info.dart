import 'package:intl/intl.dart';
import 'package:klikit/app/date_time_patterns.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/extensions.dart';

class ReportInfo {
  final String name;
  final DateType dateType;
  final DateTime dateTime;
  final DateTime? endDateTime;

  ReportInfo({
    required this.name,
    required this.dateType,
    required this.dateTime,
    this.endDateTime,
  });

  ReportInfo copyWith({String? name, DateType? dateType, DateTime? dateTime, DateTime? endDateTime}) {
    return ReportInfo(
      name: name ?? this.name,
      dateType: dateType ?? this.dateType,
      dateTime: dateTime ?? this.dateTime,
      endDateTime: endDateTime ?? this.endDateTime,
    );
  }

  String prepareSelectedItemData() {
    return (dateType == DateType.range)
        ? DateFormat(DTPatterns.dMMMyyyy).format(dateTime)
        : dateType == DateType.timeRange
            ? endDateTime != null
                ? '${dateTime.format(DTPatterns.dmmmhhmma)} - ${endDateTime!.format(DTPatterns.dmmmhhmma)}'
                : dateTime.format(DTPatterns.dmmmhhmma)
            : name;
  }
}
