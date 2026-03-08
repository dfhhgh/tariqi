import 'dart:convert';
import 'package:flutter_application_1/features/Donation/domain/repositery/payment_repository.dart';
import 'package:http/http.dart' as http;

class PaymentRepositoryImpl implements PaymentRepository {
  static const integrationId = 123456; // ضع integration id هنا

  @override
  Future<String> getPaymentKey({
    required String authToken,
    required int orderId,
    required int amount,
  }) async {
    final response = await http.post(
      Uri.parse("https://accept.paymob.com/api/acceptance/payment_keys"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "auth_token": authToken,
        "amount_cents": amount,
        "expiration": 3600,
        "order_id": orderId,
        "currency": "EGP",
        "integration_id": integrationId,
        "billing_data": {
          "first_name": "User",
          "last_name": "User",
          "email": "user@email.com",
          "phone_number": "01000000000",
          "apartment": "NA",
          "floor": "NA",
          "street": "NA",
          "building": "NA",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "EG",
          "state": "NA"
        }
      }),
    );

    final data = jsonDecode(response.body);

    return data["token"];
  }
}
