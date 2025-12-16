// lib\controllers\payment_controller.dart
import 'package:flutter/material.dart';
import '../services/payment_service.dart';
import '../presentation/screens/orders/vnpay_webview.dart';

class PaymentController {
  static Future<void> payWithVnpay({
    required BuildContext context,
    required int orderId,
    required int amount,
  }) async {
    try {
      final payUrl = await PaymentService.createVnpayPayment(
        orderId: orderId,
        amount: amount,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VnpayWebview(
            url: payUrl,
            orderId: orderId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi thanh toán VNPAY: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
