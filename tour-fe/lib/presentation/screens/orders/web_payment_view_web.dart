import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/widgets.dart';

final Set<String> _registeredViews = {};

void registerMomoIframe(String viewType, String url) {
  if (_registeredViews.contains(viewType)) return;

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    viewType,
    (int viewId) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'payment *; fullscreen *';
      return iframe;
    },
  );

  _registeredViews.add(viewType);
}

Widget buildMomoIframe(String viewType) => HtmlElementView(viewType: viewType);

