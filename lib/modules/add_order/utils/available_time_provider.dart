import 'package:intl/intl.dart';
import 'package:klikit/modules/menu/domain/entities/avilable_times.dart';

class AvailableTimeProvider {
  static final _instance = AvailableTimeProvider._internal();

  factory AvailableTimeProvider() => _instance;

  AvailableTimeProvider._internal();

  String _convertMilitaryTimeToNormalTime(int militaryTime) {
    final mins = militaryTime % 100;
    final minStr = mins < 10 ? '0$mins' : '$mins';
    final hours = (militaryTime / 100).floor();
    final hoursStr = hours < 10 ? '0$hours' : '$hours';
    return '$hoursStr:$minStr';
  }

  DayInfo _todayInfo(AvailableTimes availableTimes) {
    final today = DateTime.now().day;
    switch (today) {
      case DateTime.monday:
        return availableTimes.monday;
      case DateTime.tuesday:
        return availableTimes.tuesday;
      case DateTime.wednesday:
        return availableTimes.wednesday;
      case DateTime.thursday:
        return availableTimes.thursday;
      case DateTime.friday:
        return availableTimes.friday;
      case DateTime.saturday:
        return availableTimes.saturday;
      default:
        return availableTimes.sunday;
    }
  }

  String availableTime(AvailableTimes availableTimes) {
    final todayInfo = _todayInfo(availableTimes);
    String availableTime = "";
    for (var slot in todayInfo.slots) {
      final currentMilitaryTime = int.tryParse(
        DateFormat('HH:mm').format(DateTime.now()).replaceAll(":", ""),
        radix: 10,
      );
      print('current $currentMilitaryTime start ${slot.startTime} end${slot.endTime}');
      if (currentMilitaryTime! >= slot.startTime &&
          currentMilitaryTime <= slot.endTime) {
        final startDateTime = DateFormat('HH:mm')
            .parse(_convertMilitaryTimeToNormalTime(slot.startTime));
        final startDateTimeStr = DateFormat('hh:mm a').format(startDateTime);
        final endDateTime = DateFormat('HH:mm')
            .parse(_convertMilitaryTimeToNormalTime(slot.endTime));
        final endDateTimeStr = DateFormat('hh:mm a').format(endDateTime);
        availableTime = '$startDateTimeStr - $endDateTimeStr';
      }
    }
    return availableTime;
  }
}
