class OrderStatusName{
  static const PLACED = 'PLACED';
  static final ACCEPTED = 'ACCEPTED';
  static final CANCELLED = 'CANCELLED';
  static final READY = 'READY';
  static final DELIVERED = 'DELIVERED';
  static final SCHEDULED = 'SCHEDULED';
  static final DRIVER_ASSIGNED = 'DRIVER ASSIGNED';
  static final DRIVER_ARRIVED = 'DRIVER ARRIVED';
  static final PICKED_UP = 'PICKED UP';
}

class OrderStatus {
  final int id;
  final String status;

  OrderStatus(this.id, this.status);
}