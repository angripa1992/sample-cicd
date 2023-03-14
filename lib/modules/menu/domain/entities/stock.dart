class Stock {
  bool available;
  Snooze snooze;

  Stock({required this.available, required this.snooze});
}

class Snooze {
  String endTime;
  int duration;

  Snooze({required this.endTime, required this.duration});
}
