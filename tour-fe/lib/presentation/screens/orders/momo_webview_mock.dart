import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:tour_fe/services/order_service.dart';
import 'package:tour_fe/core/utils/order_center.dart';
import 'package:tour_fe/presentation/widgets/NavigationBar.dart';

import 'payment_success_screen.dart';
import 'web_payment_view_stub.dart'
    if (dart.library.html) 'web_payment_view_web.dart' as web_payment;

class MomoWebviewMock extends StatefulWidget {
  final String url;
  final int orderId;

  const MomoWebviewMock({
    super.key,
    required this.url,
    required this.orderId,
  });

  @override
  State<MomoWebviewMock> createState() => _MomoWebviewMockState();
}

class _MomoWebviewMockState extends State<MomoWebviewMock> {
  WebViewController? _controller;
  bool loading = true;
  String? _webViewType;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _webViewType =
          'momo-webview-${widget.orderId}-${DateTime.now().millisecondsSinceEpoch}';
      web_payment.registerMomoIframe(_webViewType!, widget.url);
      setState(() => loading = false);
    } else {
      _initMobileWebView();
    }
  }

  void _initMobileWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams();
    } else {
      params = AndroidWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => loading = true),
          onPageFinished: (_) => setState(() => loading = false),
          onWebResourceError: (err) => debugPrint("WEBVIEW ERROR: $err"),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller = controller;
  }

  _mockPaymentSuccess() async {
    await OrderService.updateStatus(widget.orderId, 3);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(orderId: widget.orderId),
      ),
    );
  }

  Future<void> _handleBackButton() async {
    // Check if order is paid (status 3 = đã thanh toán)
    final currentOrder = await OrderService.getOrderById(widget.orderId);
    if (currentOrder != null && currentOrder.typeConfirmId != 3) {
      // Order is not paid yet, show confirmation dialog
      if (!mounted) return;
      
      debugPrint("Showing confirmation dialog");
      
      // Sử dụng showGeneralDialog để có nhiều control hơn
      final result = await showGeneralDialog<bool>(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Exit Payment',
        barrierColor: Colors.black54,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const SizedBox.shrink();
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Text(
                  "Xác nhận",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: const Text(
                  "Bạn chưa thanh toán đơn hàng này, bạn có muốn thoát ra và đơn hàng sẽ lưu vào danh sách đơn hàng của bạn hay không?",
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      debugPrint("NO button pressed");
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      "NO",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      debugPrint("YES button pressed");
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "YES",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

      debugPrint("Dialog result: $result");
      if (result == true && mounted) {
        // User chose YES - update order count and go back to home
        debugPrint("User chose YES, updating order count and navigating home");
        await OrderService.fetchPendingCount();
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationBarWidget()),
            (route) => false,
          );
        }
      }
      // If NO or result is null, do nothing - user stays on payment screen
    } else {
      // Order is paid or doesn't exist, allow normal back navigation
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _handleBackButton();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Thanh toán ví MoMo "),
          backgroundColor: Colors.pink,
        ),
        body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (kIsWeb && _webViewType != null)
                  web_payment.buildMomoIframe(_webViewType!)
                else if (!kIsWeb && _controller != null)
                  WebViewWidget(controller: _controller!),
                if (loading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _mockPaymentSuccess,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF4E8A), // Màu MoMo hồng đậm
                        Color(0xFFEF3A7B), // Màu MoMo hồng sáng
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "THANH TOÁN",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
