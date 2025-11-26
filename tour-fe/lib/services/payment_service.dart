import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api.dart';

class PaymentService {
  static Future<String> createMomoPayment({
    required int orderId,
    required int amount,
  }) async {
    final url = Uri.parse(ApiConstants.momoPayment);

    final body = {
      "orderId": orderId,
      "amount": amount,
    };

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print("MOMO RAW RESPONSE: ${res.body}");
    final data = jsonDecode(res.body);

    return data["payUrl"];
  }
}
