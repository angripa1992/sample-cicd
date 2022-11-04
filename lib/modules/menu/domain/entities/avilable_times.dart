class AvailableTimes {
  final DayInfo dayOne;
  final DayInfo dayTwo;
  final DayInfo dayThree;
  final DayInfo dayFour;
  final DayInfo dayFive;
  final DayInfo daySix;
  final DayInfo daySeven;

  AvailableTimes({
    required this.dayOne,
    required this.dayTwo,
    required this.dayThree,
    required this.dayFour,
    required this.dayFive,
    required this.daySix,
    required this.daySeven,
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