import 'package:flutter/foundation.dart';

class OrderCenter {
  OrderCenter._();
  static final OrderCenter instance = OrderCenter._();

  final ValueNotifier<int> pendingCount = ValueNotifier<int>(0);

  void setCount(int value) {
    pendingCount.value = value < 0 ? 0 : value;
  }

  void reset() {
    pendingCount.value = 0;
  }
}


