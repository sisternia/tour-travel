import 'package:flutter/foundation.dart';

class NotificationCenter {
  NotificationCenter._();
  static final NotificationCenter instance = NotificationCenter._();

  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  void setCount(int value) {
    unreadCount.value = value < 0 ? 0 : value;
  }

  void decrement() {
    if (unreadCount.value == 0) return;
    unreadCount.value = unreadCount.value - 1;
  }

  void reset() {
    unreadCount.value = 0;
  }
}


