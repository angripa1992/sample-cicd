class UpdateWebShopOrderResponse {
  String? orderHash;
  String? message;
  String? status;
  bool? prePayment;
  bool? isThreePlOrder;

  UpdateWebShopOrderResponse({
    this.orderHash,
    this.status,
    this.prePayment,
    this.isThreePlOrder,
    this.message,
  });

  UpdateWebShopOrderResponse.fromJson(Map<String, dynamic> json) {
    orderHash = json['order_hash'];
    status = json['status'];
    prePayment = json['pre_payment'];
    isThreePlOrder = json['is_three_pl_order'];
  }
}
