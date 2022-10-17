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

class OrderStatusId{
  static const PLACED = 1;
  static final ACCEPTED = 2;
  static final CANCELLED = 3;
  static final READY = 4;
  static final DELIVERED = 5;
  static final SCHEDULED = 6;
  static final DRIVER_ASSIGNED = 7;
  static final DRIVER_ARRIVED = 8;
  static final PICKED_UP = 9;
}

class OrderStatus {
  final int id;
  final String status;

  OrderStatus(this.id, this.status);
}