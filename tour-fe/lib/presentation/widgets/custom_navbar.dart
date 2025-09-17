// lib/presentation/widgets/NavigationBar.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';

class NavigationBarWidget extends StatefulWidget {
  final Widget body;
  const NavigationBarWidget({super.key, required this.body});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _items = [
      Icon(Ionicons.home_outline,
          size: 28,
          color: _page == 0 ? Theme.of(context).primaryColor : Colors.black),
      Icon(Ionicons.airplane_outline,
          size: 28,
          color: _page == 1 ? Theme.of(context).primaryColor : Colors.black),
      Icon(Ionicons.bed_outline,
          size: 28,
          color: _page == 2 ? Theme.of(context).primaryColor : Colors.black),
      Icon(Ionicons.newspaper_outline,
          size: 28,
          color: _page == 3 ? Theme.of(context).primaryColor : Colors.black),
      Icon(Ionicons.person_outline,
          size: 28,
          color: _page == 4 ? Theme.of(context).primaryColor : Colors.black),
    ];

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _items,
        index: _page,
        height: 60,
        backgroundColor: Colors.transparent,
        color: Colors.grey.shade200, // nền xám nhạt
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
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
