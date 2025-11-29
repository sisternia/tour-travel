// lib\presentation\screens\orders\payment_success_screen.dart

// import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tour_fe/services/notification_service.dart';
import '../../widgets/NavigationBar.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final int orderId;

  const PaymentSuccessScreen({super.key, required this.orderId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool showCheck = false;

  @override
  void initState() {
    super.initState();

    NotificationService.fetchUnreadCount();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() => showCheck = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: showCheck
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.green,
                          size: 130,
                          key: ValueKey("check"),
                        )
                      : RotationTransition(
                          turns: Tween<double>(begin: 0, end: 2)
                              .animate(CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeOutCubic,
                          )),
                          child: Icon(
                            Icons.sync,
                            color: Colors.blue.shade400,
                            size: 120,
                            key: const ValueKey("loading"),
                          ),
                        ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Thanh toán thành công!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Đơn hàng của bạn đã được thanh toán.\nĐang chờ admin xác nhận.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xff0077FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NavigationBarWidget(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "VỀ TRANG CHỦ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
