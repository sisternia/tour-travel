// lib/presentation/screens/HomeScreen.dart
import 'package:flutter/material.dart';
import '../widgets/NavigationBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      body: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: const Center(child: Text('Đăng nhập thành công')),
      ),
    );
  }
}
