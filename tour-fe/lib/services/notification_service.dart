import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants/api.dart';
import '../core/utils/notification_center.dart';
import '../data/models/notification_model.dart';
import 'token_service.dart';

class NotificationService {
  static final _tokenService = TokenService();

  static Future<String?> _userId() => _tokenService.getUserId();

  static Future<List<NotificationModel>> fetchNotifications({
    String? query,
  }) async {
    final userId = await _userId();
    if (userId == null) return [];

    final uri = Uri.parse(ApiConstants.notificationsByUser(userId)).replace(
      queryParameters: {
        if (query != null && query.trim().isNotEmpty) 'q': query.trim(),
      },
    );

    final res = await http.get(uri);

    if (res.statusCode != 200) return [];

    final decoded = jsonDecode(res.body);
    final List list = decoded['data'] ?? [];
    final notifications =
        list.map((json) => NotificationModel.fromJson(json)).toList();

    _broadcastUnread(notifications);

    return notifications;
  }

  static Future<int> fetchUnreadCount() async {
    final userId = await _userId();
    if (userId == null) return 0;

    final uri = Uri.parse(ApiConstants.unreadNotifications(userId));
    final res = await http.get(uri);

    if (res.statusCode != 200) return 0;

    final decoded = jsonDecode(res.body);
    final count = decoded['count'] ?? 0;
    NotificationCenter.instance.setCount(count);
    return count;
  }

  static Future<bool> markAsRead(int notificationId) async {
    final userId = await _userId();
    if (userId == null) return false;

    final uri = Uri.parse(ApiConstants.markNotification(notificationId));
    final res = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (res.statusCode == 200) {
      await fetchUnreadCount();
      return true;
    }
    return false;
  }

  static Future<bool> markAllAsRead() async {
    final userId = await _userId();
    if (userId == null) return false;

    final uri = Uri.parse(ApiConstants.markAllNotifications(userId));
    final res = await http.patch(uri);

    if (res.statusCode == 200) {
      NotificationCenter.instance.reset();
      return true;
    }
    return false;
  }

  static Future<bool> deleteNotification(int notificationId) async {
    final userId = await _userId();
    if (userId == null) return false;

    final uri = Uri.parse(ApiConstants.deleteNotification(notificationId));
    final res = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (res.statusCode == 200) {
      await fetchUnreadCount();
      return true;
    }
    return false;
  }

  static void _broadcastUnread(List<NotificationModel> list) {
    final unread = list.where((item) => !item.isRead).length;
    NotificationCenter.instance.setCount(unread);
  }
}


