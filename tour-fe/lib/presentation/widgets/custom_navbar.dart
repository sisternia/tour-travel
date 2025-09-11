// lib/presentation/widgets/NavigationBar.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:tour_fe/core/constants/color.dart';

class NavigationBarWidget extends StatefulWidget {
  final Widget body;
  const NavigationBarWidget({super.key, required this.body});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

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
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _items,
        index: _page,
        backgroundColor: const Color.fromARGB(0, 188, 44, 44),
        color: bgnavicon,
        buttonBackgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: widget.body,
    );
  }
}
