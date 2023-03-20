class AvailableTimes {
  final DayInfo monday;
  final DayInfo tuesday;
  final DayInfo wednesday;
  final DayInfo thursday;
  final DayInfo friday;
  final DayInfo saturday;
  final DayInfo sunday;

  AvailableTimes({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });
}

class DayInfo {
  final bool disabled;
  final List<Slots> slots;

  DayInfo({required this.disabled, required this.slots});
}

class Slots {
  final int startTime;
  final int endTime;

  Slots({required this.startTime, required this.endTime});
}
