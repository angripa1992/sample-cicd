class MenuOutOfStock {
  bool available;
  MenuSnooze menuSnooze;

  MenuOutOfStock({
    required this.available,
    required this.menuSnooze,
  });
}

class MenuSnooze {
  String endTime;
  int duration;

  MenuSnooze({required this.endTime, required this.duration});
}
