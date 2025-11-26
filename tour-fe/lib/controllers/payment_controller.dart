import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../presentation/screens/orders/momo_webview_mock.dart';

class PaymentController {
  static Future<void> payWithMomo({
    required BuildContext context,
    required int orderId,
    required int amount,
  }) async {
    try {
      final payUrl = await PaymentService.createMomoPayment(
        orderId: orderId,
        amount: amount,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MomoWebviewMock(
            url: payUrl,
            orderId: orderId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi khi tạo thanh toán MoMo: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
