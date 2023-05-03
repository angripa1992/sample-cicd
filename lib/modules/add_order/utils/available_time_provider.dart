import 'package:intl/intl.dart';
import 'package:klikit/app/extensions.dart';
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

  DayInfo todayInfo(AvailableTimes availableTimes) {
    final today = DateTime.now().weekday;
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

  Slots? haveAvailableTime(DayInfo dayInfo){
    for (var slot in dayInfo.slots) {
      final currentMilitaryTime = int.tryParse(
        DateFormat('HH:mm').format(DateTime.now()).replaceAll(":", ""),
        radix: 10,
      );
      if (currentMilitaryTime! >= slot.startTime && currentMilitaryTime <= slot.endTime) {
        return slot;
      }
    }
    return null;
  }

  String availableTime(AvailableTimes availableTimes) {
    final slot = haveAvailableTime(todayInfo(availableTimes));
    String availableTime = 'Unavailable';
    if(slot != null){
      final startDateTime = DateFormat('HH:mm').parse(_convertMilitaryTimeToNormalTime(slot.startTime));
      final startDateTimeStr = DateFormat('hh:mm a').format(startDateTime);
      final endDateTime = DateFormat('HH:mm').parse(_convertMilitaryTimeToNormalTime(slot.endTime));
      final endDateTimeStr = DateFormat('hh:mm a').format(endDateTime);
      availableTime = '$startDateTimeStr - $endDateTimeStr';
    }
    return availableTime;
  }
}
