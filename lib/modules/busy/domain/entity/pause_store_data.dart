class PauseStoresData {
  final bool isBusy;
  final String busyModeUpdatedAt;
  final int duration;
  final int timeLeft;
  final List<PausedStore> breakdowns;

  PauseStoresData({
    required this.isBusy,
    required this.busyModeUpdatedAt,
    required this.duration,
    required this.timeLeft,
    required this.breakdowns,
  });
}

class PausedStore{
  final int brandId;
  final int branchId;
  final String brandName;
  final bool isBusy;
  final String busyModeUpdatedAt;
  final int duration;
  final int timeLeft;

  PausedStore({
    required this.brandId,
    required this.branchId,
    required this.brandName,
    required this.isBusy,
    required this.busyModeUpdatedAt,
    required this.duration,
    required this.timeLeft,
  });
}
