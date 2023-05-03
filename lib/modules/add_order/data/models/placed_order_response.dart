class PlacedOrderResponse {
  String? message;
  int? orderId;

  PlacedOrderResponse({this.message, this.orderId});

  PlacedOrderResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    orderId = json['order_id'];
  }
}
