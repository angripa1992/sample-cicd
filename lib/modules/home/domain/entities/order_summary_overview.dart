class OrderSummaryOverview {
  final int completedOrders;
  final int cancelledOrders;
  final String grossOrderValues;
  final String discountValues;

  OrderSummaryOverview(
  {
    required this.completedOrders,
    required this.cancelledOrders,
    required this.grossOrderValues,
    required this.discountValues,
}
  );
}
