class CancellationReason {
  final int id;
  final String title;
  final int cancelOrderTypeId;
  final String createdAt;

  CancellationReason({
    required this.id,
    required this.title,
    required this.cancelOrderTypeId,
    required this.createdAt,
  });
}
