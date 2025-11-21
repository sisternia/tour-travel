// lib/presentation/widgets/NavigationBar.dart
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../screens/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/tour/tourist_spot_screen.dart';

class NavigationBarWidget extends StatefulWidget {
  final Widget? body; // cho phép null
  const NavigationBarWidget({super.key, this.body});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      widget.body ?? const HomeScreen(),
      const TouristSpotScreen(),
      const Center(child: Text('Messages')),
      const Center(child: Text('Notifications')),
      const ProfileScreen(),
    ];
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
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                iconSize: 30,
              ),
              GButton(
                icon: Icons.calendar_today,
                iconSize: 30,
              ),
              GButton(
                icon: Icons.message,
                iconSize: 30,
              ),
              GButton(
                icon: Icons.notifications,
                iconSize: 30,
              ),
              GButton(
                icon: Icons.person,
                iconSize: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
