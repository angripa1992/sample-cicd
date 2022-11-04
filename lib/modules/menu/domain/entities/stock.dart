class Stock {
  final bool available;
  final Snooze snooze;

  Stock({required this.available, required this.snooze});
}

class Snooze {
  final String startTime;
  final int duration;

  Snooze({required this.startTime, required this.duration});
}
