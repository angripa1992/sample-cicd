class PaymentMethod {
  final int id;
  final String title;
  final String logo;
  final List<PaymentChannel> channels;

  PaymentMethod({
    required this.id,
    required this.title,
    required this.logo,
    required this.channels,
  });
}

class PaymentChannel {
  final int id;
  final String title;
  final String logo;
  final int sequence;
  final int paymentMethodId;

  PaymentChannel({
    required this.id,
    required this.title,
    required this.logo,
    required this.sequence,
    required this.paymentMethodId,
  });
}

class PaymentStatus {
  final int id;
  final String title;

  PaymentStatus({
    required this.id,
    required this.title,
  });
}
