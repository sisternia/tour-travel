import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tour_fe/services/order_service.dart';
import 'payment_success_screen.dart';

// WEB SUPPORT
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui' as ui;
// NEW FOR FLUTTER 3.24+
import 'dart:ui_web' as ui_web;

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
  late final String _viewId;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _viewId =
          'momo-webview-${widget.orderId}-${DateTime.now().millisecondsSinceEpoch}';

      // NEW API FOR FLUTTER 3.24+
      // ignore: undefined_prefixed_name
      ui_web.platformViewRegistry.registerViewFactory(
        _viewId,
        (int id) {
          final iframe = html.IFrameElement()
            ..src = widget.url
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%';

          return iframe;
        },
      );
    } else {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => loading = true),
            onPageFinished: (_) => setState(() => loading = false),
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  Future<void> _mockPaymentSuccess() async {
    await OrderService.updateStatus(widget.orderId, 3);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(orderId: widget.orderId),
      ),
    );
  }

  Widget _buildWebview() {
    if (kIsWeb) {
      return HtmlElementView(viewType: _viewId);
    }

    return Stack(
      children: [
        if (_controller != null) WebViewWidget(controller: _controller!),
        if (loading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán ví MoMo"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          Expanded(child: _buildWebview()),
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
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF4E8A), Color(0xFFEF3A7B)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            color: Colors.white, size: 22),
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
    );
  }
}
