class PlacedOrderResponse {
  String? message;
  String? checkoutLink;
  int? orderId;

  PlacedOrderResponse({
    this.message,
    this.orderId,
    this.checkoutLink,
  });

  PlacedOrderResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    checkoutLink = json['checkout_link'];
    orderId = json['order_id'];
  }
}
