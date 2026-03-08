abstract class PaymentRepository {
  Future<String> getPaymentKey({
    required String authToken,
    required int orderId,
    required int amount,
  });
}
