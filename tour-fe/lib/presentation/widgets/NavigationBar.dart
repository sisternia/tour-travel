// lib/presentation/widgets/NavigationBar.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tour_fe/core/utils/notification_center.dart';
import 'package:tour_fe/services/notification_service.dart';

import '../screens/home_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/post/post_header_screen.dart';
import '../screens/post/social_feed_screen.dart';
import '../screens/tour/tourist_spot_screen.dart';

class NavigationBarWidget extends StatefulWidget {
  final Widget? body;
  final int initialIndex;

  const NavigationBarWidget({
    super.key,
    this.body,
    this.initialIndex = 0,
  });

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  late int _selectedIndex;

  late final List<Widget> _screens;
  final NotificationCenter _notificationCenter = NotificationCenter.instance;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _screens = [
      widget.body ?? const HomeScreen(),
      const TouristSpotScreen(),
      const SocialFeedScreen(),
      NotificationScreen(onStateChanged: _loadUnreadCount),
      const PostHeaderScreen(),
    ];

    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    await NotificationService.fetchUnreadCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            gap: 8,
            backgroundColor: Colors.transparent,
            color: Colors.white,
            activeColor: Colors.blueAccent,
            tabBackgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() => _selectedIndex = index);
            },
            tabs: [
              const GButton(icon: Icons.home, iconSize: 30),
              const GButton(icon: Icons.calendar_today, iconSize: 30),
              const GButton(icon: Icons.people, iconSize: 30),
              GButton(
                icon: Icons.notifications_none,
                iconSize: 30,
                leading: ValueListenableBuilder<int>(
                  valueListenable: _notificationCenter.unreadCount,
                  builder: (context, count, _) {
                    final isActive = _selectedIndex == 3;
                    return _NotificationBellIcon(
                      count: count,
                      isActive: isActive,
                    );
                  },
                ),
              ),
              const GButton(icon: Icons.edit, iconSize: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBellIcon extends StatelessWidget {
  final int count;
  final bool isActive;

  const _NotificationBellIcon({
    required this.count,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.blueAccent : Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          Icons.notifications_none,
          size: 26,
          color: color,
        ),
        if (count > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
