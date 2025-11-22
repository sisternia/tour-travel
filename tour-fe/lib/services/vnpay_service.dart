import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';

class VnPayService {
  static Future<String?> createPaymentUrl({
    required int amount,
    required int orderId,
    required String orderInfo,
  }) async {
    final url = Uri.parse(ApiConstants.createVnpayUrl);

    final body = {
      "amount": amount,
      "orderId": orderId,
      "orderInfo": orderInfo,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["paymentUrl"];
    }

    return null;
  }
}
