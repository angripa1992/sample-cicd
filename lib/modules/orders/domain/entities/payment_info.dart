class PaymentMethod{
  final int id;
  final String title;
  final int sequence;

  PaymentMethod({
    required this.id,
    required this.title,
    required this.sequence,
  });
}

class PaymentStatus {
  final int id;
  final String title;

  PaymentStatus({required this.id, required this.title});
}
