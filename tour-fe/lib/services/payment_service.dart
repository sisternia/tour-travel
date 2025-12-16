// lib\services\payment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';

class PaymentService {
  static Future<String> createVnpayPayment({
    required int orderId,
    required int amount,
  }) async {
    final res = await http.post(
      Uri.parse(ApiConstants.vnpayPayment),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "orderId": orderId,
        "amount": amount,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("VNPAY CREATE FAILED");
    }

    final data = jsonDecode(res.body);
    return data["payUrl"];
  }
}
