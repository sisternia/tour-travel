// lib\presentation\screens\notification\notification_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/notification_model.dart';
import '../../../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  final VoidCallback? onStateChanged;

  const NotificationScreen({super.key, this.onStateChanged});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  Timer? _debounce;
  bool _loading = true;
  bool _markingAll = false;

  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _loadNotifications(query: _searchController.text);
    });
  }

  Future<void> _loadNotifications({String? query}) async {
    setState(() => _loading = true);
    final data = await NotificationService.fetchNotifications(query: query);
    if (!mounted) return;
    setState(() {
      _notifications = data;
      _loading = false;
    });
    widget.onStateChanged?.call();
  }

  Future<void> _markAllAsRead() async {
    if (_markingAll) return;
    setState(() => _markingAll = true);
    final success = await NotificationService.markAllAsRead();
    if (!mounted) return;
    if (success) {
      setState(() {
        _notifications =
            _notifications.map((item) => item.copyWith(isRead: true)).toList();
      });
      widget.onStateChanged?.call();
    }
    setState(() => _markingAll = false);
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;
    final success = await NotificationService.markAsRead(notification.id);
    if (!mounted || !success) return;

    setState(() {
      _notifications = _notifications.map((item) {
        if (item.id == notification.id) {
          return item.copyWith(isRead: true);
        }
        return item;
      }).toList();
    });
    widget.onStateChanged?.call();
  }

  Future<void> _deleteNotification(NotificationModel notification) async {
    final success =
        await NotificationService.deleteNotification(notification.id);
    if (!mounted || !success) return;

    setState(() {
      _notifications.removeWhere((item) => item.id == notification.id);
    });
    widget.onStateChanged?.call();
    _showSnack('Đã xoá thông báo');
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays == 1) return 'Hôm qua';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return DateFormat('dd/MM/yyyy – HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final unread =
        _notifications.where((notification) => !notification.isRead).length;

    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () =>
                _loadNotifications(query: _searchController.text.trim()),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _buildHeader(unread),
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 24),
                if (_notifications.isEmpty)
                  _buildEmptyState()
                else ...[
                  _buildSection(
                    title: 'New',
                    notifications: _notifications
                        .where((notification) => !notification.isRead)
                        .toList(),
                    showPlaceholder: unread == 0,
                  ),
                  const SizedBox(height: 18),
                  _buildSection(
                    title: 'Earlier',
                    notifications: _notifications
                        .where((notification) => notification.isRead)
                        .toList(),
                    showPlaceholder: _notifications
                        .where((notification) => notification.isRead)
                        .isEmpty,
                  ),
                ],
              ],
            ),
          );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FB),
      body: SafeArea(child: body),
    );
  }

  Widget _buildHeader(int unread) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                unread > 0
                    ? '$unread thông báo mới'
                    : 'Bạn đã xem tất cả thông báo',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => _searchFocus.requestFocus(),
          icon: const Icon(Icons.search, color: Colors.black87),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(12),
            shadowColor: Colors.black12,
            elevation: 2,
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: unread == 0 || _markingAll ? null : _markAllAsRead,
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
            disabledForegroundColor: Colors.black26,
          ),
          icon: _markingAll
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.done_all, size: 18),
          label: const Text('Đánh dấu đã đọc'),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocus,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Tìm kiếm thông báo...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: () => _searchController.clear(),
                icon: const Icon(Icons.close, size: 18),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<NotificationModel> notifications,
    required bool showPlaceholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: title == 'New' ? Colors.black87 : Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        if (showPlaceholder)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE4E7EE)),
            ),
            child: Text(
              title == 'New'
                  ? 'Không có thông báo mới'
                  : 'Chưa có thông báo cũ',
              style: const TextStyle(color: Colors.black54),
            ),
          )
        else
          ...notifications.map(
            (notification) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NotificationTile(
                notification: notification,
                timestamp: _timeAgo(notification.createdAt),
                onMarkRead: () => _markAsRead(notification),
                onDelete: () => _deleteNotification(notification),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Icon(Icons.notifications_off_outlined,
              size: 80, color: Colors.black26),
          SizedBox(height: 12),
          Text(
            'Bạn chưa có thông báo nào!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final String timestamp;
  final VoidCallback onMarkRead;
  final VoidCallback onDelete;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.timestamp,
    required this.onMarkRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    final colors = _colorsForType(notification.type);

    return Material(
      color: unread ? const Color(0xFFE8F1FF) : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onMarkRead,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: unread ? const Color(0xFFBBD7FF) : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: colors.background,
                child: Icon(colors.icon, color: colors.color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  unread ? FontWeight.w700 : FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'read') {
                              onMarkRead();
                            } else if (value == 'delete') {
                              onDelete();
                            }
                          },
                          itemBuilder: (context) => [
                            if (unread)
                              const PopupMenuItem(
                                value: 'read',
                                child: Text('Đánh dấu đã đọc'),
                              ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Xoá thông báo'),
                            ),
                          ],
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.body,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: unread
                                ? const Color(0xFF3B82F6)
                                : Colors.black26,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timestamp,
                          style: TextStyle(
                            fontSize: 13,
                            color: unread ? Colors.black87 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _NotificationColors _colorsForType(String type) {
    switch (type) {
      case 'payment':
        return _NotificationColors(
          icon: Icons.card_travel,
          color: const Color(0xFF2563EB),
          background: const Color(0xFFDDE7FF),
        );
      case 'profile':
        return _NotificationColors(
          icon: Icons.person,
          color: const Color(0xFF6C63FF),
          background: const Color(0xFFE6E4FF),
        );
      default:
        return _NotificationColors(
          icon: Icons.notifications,
          color: Colors.orange.shade700,
          background: const Color(0xFFFFF0DA),
        );
    }
  }
}

class _NotificationColors {
  final IconData icon;
  final Color color;
  final Color background;

  const _NotificationColors({
    required this.icon,
    required this.color,
    required this.background,
  });
}
