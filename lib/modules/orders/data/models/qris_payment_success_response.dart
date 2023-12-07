class QrisUpdatePaymentResponse {
  String? checkoutLink;

  QrisUpdatePaymentResponse({this.checkoutLink});

  QrisUpdatePaymentResponse.fromJson(Map<String, dynamic> json) {
    checkoutLink = json['checkout_link'];
  }
}
