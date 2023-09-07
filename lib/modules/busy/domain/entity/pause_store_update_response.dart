class PauseStoreUpdateResponse {
  final int duration;
  final int timeLeft;
  final String message;
  final List<String> warnings;

  PauseStoreUpdateResponse({
    required this.duration,
    required this.timeLeft,
    required this.message,
    required this.warnings,
  });
}
