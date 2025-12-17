// lib/presentation/screens/orders/vnpay_webview.dart
import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _handled = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _openVnpayOnWeb();
    } else {
      _initMobileWebView();
    }
  }

  Future<void> _openVnpayOnWeb() async {
    final uri = Uri.parse(widget.url);

    await launchUrl(uri, mode: LaunchMode.externalApplication);

    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      final order = await OrderService.getOrderById(widget.orderId);
      if (order != null && order.typeConfirmId == 3 && mounted) {
        _pollTimer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentSuccessScreen(orderId: widget.orderId),
          ),
        );
      }
    });
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
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.startsWith("vnpay-return://success")) {
              _goSuccess();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (url) async {
            if (!mounted || _handled) return;

            if (url.contains("/api/vnpay/return")) {
              final order = await OrderService.getOrderById(widget.orderId);
              if (order != null && order.typeConfirmId == 3) {
                _goSuccess();
              }
            }

            setState(() => loading = false);
          },
          onPageStarted: (_) {
            if (mounted) setState(() => loading = true);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _goSuccess() {
    if (_handled) return;
    _handled = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(orderId: widget.orderId),
      ),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
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
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
