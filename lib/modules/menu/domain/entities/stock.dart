class Stock {
  bool available;
  Snooze snooze;

  Stock({required this.available, required this.snooze});
}

class Snooze {
  String startTime;
  int duration;

  Snooze({required this.startTime, required this.duration});
}
