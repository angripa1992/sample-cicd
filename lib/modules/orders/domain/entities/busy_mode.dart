class BusyModeGetResponse {
  final bool isBusy;
  final String updatedAt;
  final int timeLeft;
  final int duration;

  BusyModeGetResponse({
    required this.isBusy,
    required this.updatedAt,
    required this.timeLeft,
    required this.duration,
  });
}

class BusyModePostResponse {
  final String message;
  final List<String> warning;
  final bool isBusy;
  final int timeLeft;
  final int duration;

  BusyModePostResponse({
    required this.message,
    required this.warning,
    this.isBusy = false,
    required this.timeLeft,
    required this.duration,
  });

  BusyModePostResponse copyWithBusyMode(bool isBusy) {
    return BusyModePostResponse(
      message: message,
      warning: warning,
      isBusy: isBusy,
      duration: duration,
      timeLeft: timeLeft,
    );
  }
}
