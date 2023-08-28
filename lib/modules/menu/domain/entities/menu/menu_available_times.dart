class MenuAvailableTimes{
  final MenuDay monday;
  final MenuDay tuesday;
  final MenuDay wednesday;
  final MenuDay thursday;
  final MenuDay friday;
  final MenuDay saturday;
  final MenuDay sunday;

  MenuAvailableTimes({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });
}

class MenuDay {
  final bool disabled;
  final List<MenuSlots> slots;

  MenuDay({required this.disabled, required this.slots});
}

class MenuSlots {
  final int startTime;
  final int endTime;

  MenuSlots({required this.startTime, required this.endTime});
}
