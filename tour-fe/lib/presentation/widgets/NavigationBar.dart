// lib/presentation/widgets/NavigationBar.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../screens/home_screen.dart';
import '../screens/profile/profile_screen.dart';
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
  late int _page;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _page = widget.initialIndex;

    _screens = [
      widget.body ?? const HomeScreen(),
      const TouristSpotScreen(),
      const Center(child: Text('Messages')),
      const Center(child: Text('Notifications')),
      const ProfileScreen(),
    ];
  }

  final List<Icon> _items = const [
    Icon(Icons.home, size: 30),
    Icon(Icons.calendar_today, size: 30),
    Icon(Icons.message, size: 30),
    Icon(Icons.notifications, size: 30),
    Icon(Icons.person, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _items,
        index: _page,
        backgroundColor: Colors.transparent,
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        onTap: (index) => setState(() => _page = index),
      ),
    );
  }
}
