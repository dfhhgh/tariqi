class PaymentEntity {
  final int amount;
  final int orderId;
  final String token;

  PaymentEntity({
    required this.amount,
    required this.orderId,
    required this.token,
  });
}
