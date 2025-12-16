// lib\presentation\screens\orders\web_payment_view_web.dart
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/widgets.dart';

final Set<String> _registered = {};

void registerPaymentIframe(String viewType, String url) {
  if (_registered.contains(viewType)) return;

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    viewType,
    (int id) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'payment *';
      return iframe;
    },
  );

  _registered.add(viewType);
}

Widget buildPaymentIframe(String viewType) =>
    HtmlElementView(viewType: viewType);
