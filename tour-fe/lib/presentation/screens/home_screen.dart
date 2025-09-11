// lib/presentation/screens/HomeScreen.dart
import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import '../../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final name = await StorageService.getUsername();
    print('Loaded username: $name'); // Debug
    setState(() {
      _username = name ?? 'Không xác định';
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBarWidget(
      body: Scaffold(
        appBar: AppBar(title: const Text('Home')),
        body: Center(
          child: Text(
            _username != null ? "Xin chào, $_username 👋" : "Đang tải...",
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
