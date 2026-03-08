import 'package:flutter_application_1/features/Donation/domain/repositery/payment_repository.dart';

class GetPaymentKeyUseCase {
  final PaymentRepository repository;

  GetPaymentKeyUseCase(this.repository);

  Future<String> call({
    required String token,
    required int orderId,
    required int amount,
  }) {
    return repository.getPaymentKey(
      authToken: token,
      orderId: orderId,
      amount: amount,
    );
  }
}
