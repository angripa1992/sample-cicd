import 'package:intl/intl.dart';
import 'package:klikit/app/enums.dart';

class ReportInfo {
  final String name;
  final DateType dateType;
  final DateTime dateTime;

  ReportInfo({
    required this.name,
    required this.dateType,
    required this.dateTime,
  });

  ReportInfo copyWith({String? name, DateType? dateType, DateTime? dateTime}) {
    return ReportInfo(
      name: name ?? this.name,
      dateType: dateType ?? this.dateType,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  String prepareSelectedItemData() {
    return (dateType == DateType.range) ? DateFormat('d MMM yyyy').format(dateTime) : name;
  }
}
