// lib/presentation/screens/HomeScreen.dart
import 'package:flutter/material.dart';
import 'package:tour_fe/presentation/screens/profile_screen.dart';
import '../widgets/NavigationBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const NavigationBarWidget(
      body: Center(child: Text('Đăng nhập thành công')),
    );
  }
}
