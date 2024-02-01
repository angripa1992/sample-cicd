class NotificationCounter {
  /// type: 1,
  final int ongoing;

  /// type: 2,
  final int cancelled;

  /// type: 3,
  final int scheduled;

  NotificationCounter({required this.ongoing, required this.scheduled, required this.cancelled});

  int totalCount() {
    return ongoing + cancelled + scheduled;
  }

  int totalAvailableTypes() {
    return (ongoing > 0 ? 1 : 0) + (cancelled > 0 ? 1 : 0) + (scheduled > 0 ? 1 : 0);
  }

  NotificationCounter copyWith({int? ongoing, int? cancelled, int? scheduled}) {
    return NotificationCounter(
      ongoing: ongoing ?? this.ongoing,
      cancelled: cancelled ?? this.cancelled,
      scheduled: scheduled ?? this.scheduled,
    );
  }
}
