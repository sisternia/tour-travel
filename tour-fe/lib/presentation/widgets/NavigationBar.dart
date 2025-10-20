// lib/presentation/widgets/NavigationBar.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ionicons/ionicons.dart';
import '../screens/home_screen.dart';
import '../screens/tourist_spot_screen.dart';

class NavigationBarWidget extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  const NavigationBarWidget(
      {super.key, required this.body, required this.currentIndex});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  late int _page;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Icon> _items = const [
    Icon(Ionicons.home_outline, size: 30),
    Icon(Ionicons.umbrella_outline, size: 30),
    Icon(Ionicons.calendar_outline, size: 30),
    Icon(Ionicons.chatbubble_outline, size: 30),
    Icon(Ionicons.person_outline, size: 30),
  ];

  @override
  void initState() {
    super.initState();
    _page = widget.currentIndex;
  }

  void _navigateToPage(int index) {
    if (index == _page) return;

    Widget target;
    switch (index) {
      case 0:
        target = const HomeScreen();
        break;
      case 1:
        target = const TouristSpotScreen();
        break;
      default:
        setState(() {
          _page = index;
        });
        return;
    }

    setState(() {
      _page = index;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => target,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _items,
        index: _page,
        backgroundColor: Colors.transparent,
        color: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        onTap: _navigateToPage,
      ),
      body: widget.body,
    );
  }
}
