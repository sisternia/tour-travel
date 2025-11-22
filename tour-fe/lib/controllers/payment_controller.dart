import 'package:url_launcher/url_launcher.dart';
import '../services/vnpay_service.dart';

class PaymentController {
  static Future<void> payWithVnPay({
    required int amount,
    required int orderId,
  }) async {
    final paymentUrl = await VnPayService.createPaymentUrl(
      amount: amount,
      orderId: orderId,
      orderInfo: "Thanh toán đơn hàng #$orderId",
    );

    if (paymentUrl == null) {
      throw Exception("Không tạo được URL thanh toán");
    }

    final encodedUrl = Uri.encodeFull(paymentUrl);

    if (!await launchUrl(Uri.parse(encodedUrl),
        mode: LaunchMode.externalApplication)) {
      throw Exception("Không thể mở VNPAY");
    }
  }
}
