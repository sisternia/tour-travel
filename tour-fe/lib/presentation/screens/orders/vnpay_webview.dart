// lib/presentation/screens/orders/vnpay_webview.dart
import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../services/order_service.dart';
import 'payment_success_screen.dart';

class VnpayWebview extends StatefulWidget {
  final String url;
  final int orderId;

  const VnpayWebview({
    super.key,
    required this.url,
    required this.orderId,
  });

  @override
  State<VnpayWebview> createState() => _VnpayWebviewState();
}

class _VnpayWebviewState extends State<VnpayWebview> {
  WebViewController? _controller;
  bool loading = true;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // WEB: mở tab mới (VNPAY không cho iframe)
      html.window.open(widget.url, '_blank');

      // Poll trạng thái đơn hàng
      _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
        final order = await OrderService.getOrderById(widget.orderId);
        if (order != null && order.typeConfirmId == 3) {
          _pollTimer?.cancel();
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentSuccessScreen(orderId: widget.orderId),
              ),
            );
          }
        }
      });
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

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _checkPayment() async {
    final order = await OrderService.getOrderById(widget.orderId);
    if (order != null && order.typeConfirmId == 3 && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(orderId: widget.orderId),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // WEB: chỉ chờ polling
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán VNPAY"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          if (_controller != null) WebViewWidget(controller: _controller!),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkPayment,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
