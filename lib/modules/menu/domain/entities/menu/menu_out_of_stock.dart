class MenuOutOfStock {
  bool available;
  MenuSnooze menuSnooze;

  MenuOutOfStock({
    required this.available,
    required this.menuSnooze,
  });
}

class MenuSnooze {
  String startTime;
  String endTime;
  int duration;
  String unit;

  MenuSnooze({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.unit,
  });
}
