class ItemStock {
  bool available;
  ItemSnooze snooze;

  ItemStock({required this.available, required this.snooze});
}

class ItemSnooze {
  String endTime;
  int duration;

  ItemSnooze({
    required this.endTime,
    required this.duration,
  });
}
